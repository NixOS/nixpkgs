{
<<<<<<< HEAD
  lib,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  stdenv,
  pdfium-binaries,
}:

{ version, src, ... }:

<<<<<<< HEAD
stdenv.mkDerivation {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "pdfrx";
  inherit version src;
  inherit (src) passthru;

<<<<<<< HEAD
  postPatch = lib.optionalString (lib.versionOlder version "2.2.9") ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "\''${PDFIUM_DIR}/\''${PDFIUM_RELEASE}" "${pdfium-binaries}"
=======
  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
        --replace-fail "\''${PDFIUM_DIR}/\''${PDFIUM_RELEASE}" "${pdfium-binaries}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    cp --recursive . $out
=======
    mkdir $out
    cp -a ./* $out/
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';
}
