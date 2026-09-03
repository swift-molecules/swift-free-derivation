// swift-tools-version: 6.4

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-free-derivation",
    products: [
        .library(name: "Free Derivation", targets: ["Free Derivation"]),
        .library(name: "Free Derivation Core", targets: ["Free Derivation Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-base-functor-derivation.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(
            name: "Free Derivation Core",
            dependencies: [
                .product(name: "Base Functor Derivation Core", package: "swift-base-functor-derivation"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
        .macro(
            name: "Free Derivation Macros",
            dependencies: [
                "Free Derivation Core",
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .target(name: "Free Derivation", dependencies: ["Free Derivation Macros"]),
        .testTarget(
            name: "Free Derivation Tests",
            dependencies: ["Free Derivation"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
