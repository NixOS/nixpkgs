{
  stdenv,
  pdfium-binaries,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "pdfrx";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
        --replace-fail "\''${PDFIUM_DIR}/\''${PDFIUM_RELEASE}" "${pdfium-binaries}"
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -a ./* $out/

    runHook postInstall
  '';
}
