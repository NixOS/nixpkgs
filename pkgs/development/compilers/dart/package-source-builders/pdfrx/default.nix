{
  lib,
  stdenv,
  pdfium,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "pdfrx";
  inherit version src;
  inherit (src) passthru;

  postPatch = lib.optionalString (lib.versionOlder version "2.2.9") ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "\''${PDFIUM_DIR}/\''${PDFIUM_RELEASE}" "${pdfium}"
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive . $out

    runHook postInstall
  '';
}
