{
  lib,
  stdenv,
  fetchurl,
  cairo,
  fftwSinglePrec,
  libx11,
  libxft,
  libclthreads,
  libclxclient,
  libjack2,
  xorgproto,
  zita-resampler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zita-at1";
  version = "0.8.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-at1-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-NSYTJmgOmL/CgGI/rBGQuqmccZEzvwYgchb7e4XqmmM=";
  };

  buildInputs = [
    cairo
    fftwSinglePrec
    libx11
    libxft
    libclthreads
    libclxclient
    libjack2
    xorgproto
    zita-resampler
  ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Autotuner Jack application to correct the pitch of vocal tracks";
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "zita-at1";
  };
})
