{
  lib,
  stdenv,
  pdfium-binaries,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "pdfium_dart";
  inherit version src;
  inherit (src) passthru;

  postPatch = lib.optionalString (lib.versionAtLeast version "0.2.0") ''
    substitute ${./build.dart} hook/build.dart \
      --replace-fail "@pdfium-binaries@" "${pdfium-binaries}"
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive . $out

    runHook postInstall
  '';
}
