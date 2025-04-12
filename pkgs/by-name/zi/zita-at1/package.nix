{
  lib,
  stdenv,
  fetchurl,
  cairo,
  fftwSinglePrec,
  libX11,
  libXft,
  libclthreads,
  libclxclient,
  libjack2,
  xorgproto,
  zita-resampler,
}:

stdenv.mkDerivation rec {
  pname = "zita-at1";
  version = "0.8.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-NSYTJmgOmL/CgGI/rBGQuqmccZEzvwYgchb7e4XqmmM=";
  };

  buildInputs = [
    cairo
    fftwSinglePrec
    libX11
    libXft
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

  meta = with lib; {
    description = "Autotuner Jack application to correct the pitch of vocal tracks";
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    mainProgram = "zita-at1";
  };
}
