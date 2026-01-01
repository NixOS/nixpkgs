{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  zlib,
  freetype,
  libjpeg,
  libtiff,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "pdfhummus";
<<<<<<< HEAD
  version = "4.8.1";
=======
  version = "4.8.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "galkahana";
    repo = "PDF-Writer";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uTy7XUUCje57pcwACNeeEMwdLCjsMMV5nSOmg9JpeRc=";
=======
    hash = "sha256-VfuA1Xg0kudHfP/Hi1JvQfzVDuBumAkLr+SirPqSBTs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qtbase
  ];

  propagatedBuildInputs = [
    zlib
    freetype
    libjpeg
    libtiff
    libpng
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DUSE_BUNDLED=OFF"
    # Use bundled LibAesgm
    "-DUSE_UNBUNDLED_FALLBACK_BUNDLED=ON"
  ];

<<<<<<< HEAD
  meta = {
    description = "Fast and Free C++ Library for Creating, Parsing an Manipulating PDF Files and Streams";
    homepage = "https://www.pdfhummus.com";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wineee ];
=======
  meta = with lib; {
    description = "Fast and Free C++ Library for Creating, Parsing an Manipulating PDF Files and Streams";
    homepage = "https://www.pdfhummus.com";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wineee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
