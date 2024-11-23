{
  lib,
  pkgs,
  newScope,
  darwin,
  llvmPackages,
  llvmPackages_15,
  overrideCC,
  overrideLibcxx,
}:

let
  swiftLlvmPackages = llvmPackages_15;

  self = rec {

    callPackage = newScope self;

    # Current versions of Swift on Darwin require macOS SDK 10.15 at least.
    # The Swift compiler propagates the 13.3 SDK and a 10.15 deployment target.
    # Packages that need a newer version can add it to their build inputs
    # to use it (as normal).

    # This SDK is included for compatibility with existing packages.
    apple_sdk = pkgs.darwin.apple_sdk_11_0;

    # Swift builds its own Clang for internal use. We wrap that clang with a
    # cc-wrapper derived from the clang configured below. Because cc-wrapper
    # applies a specific resource-root, the two versions are best matched, or
    # we'll often run into compilation errors.
    #
    # The following selects the correct Clang version, matching the version
    # used in Swift.
    inherit (swiftLlvmPackages) clang;

    # Overrides that create a useful environment for swift packages, allowing
    # packaging with `swiftPackages.callPackage`.
    inherit (clang) bintools;
    stdenv =
      let
        stdenv' = overrideCC pkgs.stdenv clang;
      in
      # Ensure that Swift’s internal clang uses the same libc++ and libc++abi as the
      # default clang’s stdenv. Using the default libc++ avoids issues (such as crashes)
      # that can happen when a Swift application dynamically links different versions
      # of libc++ and libc++abi than libraries it links are using.
      if stdenv'.cc.libcxx != null then overrideLibcxx stdenv' else stdenv';

    swift-unwrapped = callPackage ./compiler {
      inherit (darwin) DarwinTools sigtool;
    };

    swiftNoSwiftDriver = callPackage ./wrapper {
      swift = swift-unwrapped;
      useSwiftDriver = false;
    };

    Dispatch =
      if stdenv.hostPlatform.isDarwin then
        null # part of apple-sdk
      else
        callPackage ./libdispatch { swift = swiftNoSwiftDriver; };

    Foundation =
      if stdenv.hostPlatform.isDarwin then
        null # part of apple-sdk
      else
        callPackage ./foundation { swift = swiftNoSwiftDriver; };

    # TODO: Apple distributes a binary XCTest with Xcode, but it is not part of
    # CLTools (or SUS), so would have to figure out how to fetch it. The binary
    # version has several extra features, like a test runner and ObjC support.
    XCTest = callPackage ./xctest {
      inherit (darwin) DarwinTools;
      swift = swiftNoSwiftDriver;
    };

    swiftpm = callPackage ./swiftpm {
      inherit (darwin) DarwinTools;
      inherit (apple_sdk.frameworks) CryptoKit LocalAuthentication;
      swift = swiftNoSwiftDriver;
    };

    swift-driver = callPackage ./swift-driver {
      swift = swiftNoSwiftDriver;
    };

    swift = callPackage ./wrapper {
      swift = swift-unwrapped;
    };

    sourcekit-lsp = callPackage ./sourcekit-lsp {
      inherit (apple_sdk.frameworks) CryptoKit LocalAuthentication;
    };

    swift-docc = callPackage ./swift-docc {
      inherit (apple_sdk.frameworks) CryptoKit LocalAuthentication;
    };

    swift-format = callPackage ./swift-format { };

    swiftpm2nix = callPackage ./swiftpm2nix { };

  };

in
self
