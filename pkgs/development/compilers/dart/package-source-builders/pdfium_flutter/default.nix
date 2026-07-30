{
  lib,
  stdenv,
  pdfium-binaries,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "pdfium_flutter";
  inherit version src;
  inherit (src) passthru;

  postPatch = lib.optionalString (lib.versionOlder version "0.2.0") ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "\''${PDFIUM_DIR}/\''${PDFIUM_RELEASE}" "${pdfium-binaries}"
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive . $out

    runHook postInstall
  '';
}
