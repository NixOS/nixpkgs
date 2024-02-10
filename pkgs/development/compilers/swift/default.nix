{ lib
, pkgs
, newScope
, darwin
, llvmPackages
, llvmPackages_15
, overrideCC
}:

let
  swiftLlvmPackages = llvmPackages_15;

  self = rec {

    callPackage = newScope self;

    # Current versions of Swift on Darwin require macOS SDK 10.15 at least.
    # Re-export this so we can rely on the minimum Swift SDK elsewhere.
    apple_sdk = pkgs.darwin.apple_sdk_11_0;

    # Swift builds its own Clang for internal use. We wrap that clang with a
    # cc-wrapper derived from the clang configured below. Because cc-wrapper
    # applies a specific resource-root, the two versions are best matched, or
    # we'll often run into compilation errors.
    #
    # The following selects the correct Clang version, matching the version
    # used in Swift, and applies the same libc overrides as `apple_sdk.stdenv`.
    clang = if pkgs.stdenv.isDarwin
      then
        swiftLlvmPackages.clang.override rec {
          libc = apple_sdk.Libsystem;
          bintools = pkgs.bintools.override { inherit libc; };
          # Ensure that Swift’s internal clang uses the same libc++ and libc++abi as the
          # default Darwin stdenv. Using the default libc++ avoids issues (such as crashes)
          # that can happen when a Swift application dynamically links different versions
          # of libc++ and libc++abi than libraries it links are using.
          inherit (llvmPackages) libcxx;
          extraPackages = [
            llvmPackages.libcxxabi
            # Use the compiler-rt associated with clang, but use the libc++abi from the stdenv
            # to avoid linking against two different versions (for the same reasons as above).
            (swiftLlvmPackages.compiler-rt.override {
              inherit (llvmPackages) libcxxabi;
            })
          ];
        }
      else
        swiftLlvmPackages.clang;

    # Overrides that create a useful environment for swift packages, allowing
    # packaging with `swiftPackages.callPackage`. These are similar to
    # `apple_sdk_11_0.callPackage`, with our clang on top.
    inherit (clang) bintools;
    stdenv = overrideCC pkgs.stdenv clang;
    darwin = pkgs.darwin.overrideScope (_: prev: {
      inherit apple_sdk;
      inherit (apple_sdk) Libsystem LibsystemCross libcharset libunwind objc4 configd IOKit Security;
      CF = apple_sdk.CoreFoundation // { __attrsFailEvaluation = true; };
      __attrsFailEvaluation = true;
    });
    xcodebuild = pkgs.xcbuild.override {
      inherit (apple_sdk.frameworks) CoreServices CoreGraphics ImageIO;
      inherit stdenv;
      sdkVer = "10.15";
    };
    xcbuild = xcodebuild;

    swift-unwrapped = callPackage ./compiler {
      inherit (darwin) DarwinTools cctools sigtool;
      inherit (apple_sdk) MacOSX-SDK CLTools_Executables;
      inherit (apple_sdk.frameworks) CoreServices Foundation Combine;
    };

    swiftNoSwiftDriver = callPackage ./wrapper {
      swift = swift-unwrapped;
      useSwiftDriver = false;
    };

    Dispatch = if stdenv.isDarwin
      then null # part of libsystem
      else callPackage ./libdispatch { swift = swiftNoSwiftDriver; };

    Foundation = if stdenv.isDarwin
      then apple_sdk.frameworks.Foundation
      else callPackage ./foundation { swift = swiftNoSwiftDriver; };

    # TODO: Apple distributes a binary XCTest with Xcode, but it is not part of
    # CLTools (or SUS), so would have to figure out how to fetch it. The binary
    # version has several extra features, like a test runner and ObjC support.
    XCTest = callPackage ./xctest {
      inherit (darwin) DarwinTools;
      swift = swiftNoSwiftDriver;
    };

    swiftpm = callPackage ./swiftpm {
      inherit (darwin) DarwinTools cctools;
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

  };

in self
