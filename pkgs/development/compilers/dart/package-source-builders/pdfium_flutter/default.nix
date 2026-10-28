{
  lib,
  stdenv,
  pdfium,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "pdfium_flutter";
  inherit version src;
  inherit (src) passthru;

  postPatch = lib.optionalString (lib.versionOlder version "0.2.0") ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "set(PDFIUM_RELEASE_DIR \''${PDFIUM_DIR}/\''${PDFIUM_RELEASE})" "set(PDFIUM_RELEASE_DIR ${lib.getLib pdfium})" \
      --replace-fail "file(COPY \''${PDFIUM_RELEASE_DIR}/include DESTINATION \''${PDFIUM_LIBS_DIR})" "file(COPY ${lib.getDev pdfium}/include DESTINATION \''${PDFIUM_LIBS_DIR})"
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive . $out

    runHook postInstall
  '';
}
