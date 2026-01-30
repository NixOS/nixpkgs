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
  libpthread-stubs,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yoshimi";
  version = "2.3.5.2";

  src = fetchFromGitHub {
    owner = "Yoshimi";
    repo = "yoshimi";
    rev = finalAttrs.version;
    hash = "sha256-X4g4AhPHg2ezHnAm8fWunatZgr3/PZxibzACplWogo8=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

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
    libpthread-stubs
    zlib
  ];

  cmakeFlags = [ "-DFLTK_MATH_LIBRARY=${stdenv.cc.libc}/lib/libm.so" ];

  meta = {
    description = "High quality software synthesizer based on ZynAddSubFX";
    longDescription = ''
      Yoshimi delivers the same synthesizer capabilities as
      ZynAddSubFX along with very good Jack and Alsa midi/audio
      functionality on Linux
    '';
    homepage = "https://yoshimi.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "yoshimi";
  };
})
