{
  stdenv,
  pdfium,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "pdfium_flutter";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "\''${PDFIUM_DIR}/\''${PDFIUM_RELEASE}" "${pdfium}"
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive . $out

    runHook postInstall
  '';
}
