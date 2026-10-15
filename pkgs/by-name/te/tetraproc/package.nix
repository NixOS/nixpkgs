{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  expat,
  fftwFloat,
  fontconfig,
  freetype,
  libjack2,
  jack2,
  libclthreads,
  libclxclient,
  libsndfile,
  libxcb,
  libxrender,
  libxft,
  libxdmcp,
  libxau,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tetraproc";
  version = "0.10.0";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/tetraproc-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-rDnFyjWaFdHcEdREdIEUGK95xg1Ghpj7rADgGq5VOXw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    expat
    libjack2
    libclthreads
    libclxclient
    fftwFloat
    fontconfig
    libsndfile
    freetype
    libxcb
    libx11
    libxau
    libxdmcp
    libxft
    libxrender
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preConfigure = ''
    cd ./source/
  '';

  postInstall = ''
    # Make sure Jack is available in $PATH for tetraproc
    wrapProgram $out/bin/tetraproc --prefix PATH : "${jack2}/bin"
  '';

  meta = {
    description = "Converts the A-format signals from a tetrahedral Ambisonic microphone into B-format signals ready for recording";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
