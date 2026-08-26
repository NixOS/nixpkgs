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

  # The darwin variant also serves OS.macOS from libpdfium.dylib; the linux
  # variant stays byte-identical to the one already in nixpkgs so linux
  # derivations keep their old hashes.
  postPatch =
    if stdenv.hostPlatform.isDarwin then
      lib.optionalString (lib.versionAtLeast version "0.2.0") ''
        substitute ${./build-darwin.dart} hook/build.dart \
          --replace-fail "@pdfium-binaries@" "${pdfium-binaries}"
      ''
    else
      lib.optionalString (lib.versionAtLeast version "0.2.0") ''
        substitute ${./build.dart} hook/build.dart \
          --replace-fail "@pdfium-binaries@" "${pdfium-binaries}"
      '';

  installPhase = ''
    runHook preInstall

    cp --recursive . $out

    runHook postInstall
  '';
}
