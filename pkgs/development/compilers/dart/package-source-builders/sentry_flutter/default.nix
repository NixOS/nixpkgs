{
  lib,
  stdenv,
  fetchFromGitHub,
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sentry_flutter";
  inherit version src;
  inherit (src) passthru;

  postPatch = lib.optionalString (lib.versionAtLeast version "8.10.0") ''
    sed -i "s|GIT_REPOSITORY.*|SOURCE_DIR "${sentry-native}"|" sentry-native/sentry-native.cmake
    sed -i '/GIT_TAG/d' sentry-native/sentry-native.cmake
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
})
