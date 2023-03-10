{ lib
, pkgs
, newScope
, darwin
, llvmPackages_latest
, overrideCC
}:

let
  self = rec {

    callPackage = newScope self;

    # Current versions of Swift on Darwin require macOS SDK 10.15 at least.
    # Re-export this so we can rely on the minimum Swift SDK elsewhere.
    apple_sdk = pkgs.darwin.apple_sdk_11_0;

    # Our current Clang on Darwin is v11, but we need at least v12. The
    # following applies the newer Clang with the same libc overrides as
    # `apple_sdk.stdenv`.
    #
    # If 'latest' becomes an issue, recommend replacing it with v14, which is
    # currently closest to the official Swift builds.
    clang = if pkgs.stdenv.isDarwin
      then
        llvmPackages_latest.clang.override rec {
          libc = apple_sdk.Libsystem;
          bintools = pkgs.bintools.override { inherit libc; };
        }
      else
        llvmPackages_latest.clang;

    # Overrides that create a useful environment for swift packages, allowing
    # packaging with `swiftPackages.callPackage`. These are similar to
    # `apple_sdk_11_0.callPackage`, with our clang on top.
    inherit (clang) bintools;
    stdenv = overrideCC pkgs.stdenv clang;
    darwin = pkgs.darwin.overrideScope (_: prev: {
      inherit apple_sdk;
      inherit (apple_sdk) Libsystem LibsystemCross libcharset libunwind objc4 configd IOKit Security;
      CF = apple_sdk.CoreFoundation;
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

  };

in self
