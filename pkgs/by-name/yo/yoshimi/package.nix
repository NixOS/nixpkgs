{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  boost,
  cairo,
  cmake,
  fftwSinglePrec,
  fltk,
  libGLU,
  libjack2,
  libsndfile,
  libXdmcp,
  lv2,
  minixml,
  pcre,
  pkg-config,
  readline,
  xorg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "yoshimi";
  version = "2.3.5.2";

  src = fetchFromGitHub {
    owner = "Yoshimi";
    repo = "yoshimi";
    rev = version;
    hash = "sha256-X4g4AhPHg2ezHnAm8fWunatZgr3/PZxibzACplWogo8=";
  };

  sourceRoot = "${src.name}/src";

  postPatch = ''
    substituteInPlace Misc/Config.cpp --replace /usr $out
    substituteInPlace Misc/Bank.cpp --replace /usr $out
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    boost
    cairo
    fftwSinglePrec
    fltk
    libGLU
    libjack2
    libsndfile
    libXdmcp
    lv2
    minixml
    pcre
    readline
    xorg.libpthreadstubs
    zlib
  ];

  cmakeFlags = [ "-DFLTK_MATH_LIBRARY=${stdenv.cc.libc}/lib/libm.so" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "High quality software synthesizer based on ZynAddSubFX";
    longDescription = ''
      Yoshimi delivers the same synthesizer capabilities as
      ZynAddSubFX along with very good Jack and Alsa midi/audio
      functionality on Linux
    '';
    homepage = "https://yoshimi.github.io/";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
=======
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "yoshimi";
  };
}
