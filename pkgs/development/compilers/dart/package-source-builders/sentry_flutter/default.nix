{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
}:

{ version, src, ... }:

let
  sentry-native = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    tag = "0.9.1";
    fetchSubmodules = true;
    hash = "sha256-1jyJGiIrX0TsRDzAeg3IuE1Vf5STAaG8JVxdbmPMXGQ=";
  };
  sentry-cocoa =
    assert version == "9.30.0" || throw "sentry_flutter: missing Darwin SDK source pin for ${version}";
    fetchFromGitHub {
      owner = "getsentry";
      repo = "sentry-cocoa";
      tag = "8.58.4";
      hash = "sha256-l2V965SYfsfh6M578/wuKVm6qz9kC7qUI8A9lCmLbhA=";
    };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "sentry_flutter";
  inherit version src;
  inherit (src) passthru;

  postPatch =
    lib.optionalString (stdenv.hostPlatform.isLinux && lib.versionAtLeast version "8.10.0") ''
      sed -i "s|GIT_REPOSITORY.*|SOURCE_DIR "${sentry-native}"|" sentry-native/sentry-native.cmake
      sed -i '/GIT_TAG/d' sentry-native/sentry-native.cmake
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Upstream SwiftPM uses a precompiled Sentry framework. CocoaPods can build
      # the same SDK from the pinned source supplied by Nix.
      rm macos/sentry_flutter/Package.swift
    '';

  setupHook = lib.optionalString stdenv.hostPlatform.isDarwin (
    writeText "sentry-cocoa-hook" ''
      export NIX_FLUTTER_COCOAPODS="''${NIX_FLUTTER_COCOAPODS:+$NIX_FLUTTER_COCOAPODS:}Sentry/HybridSDK=${sentry-cocoa}"
    ''
  );

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
})
