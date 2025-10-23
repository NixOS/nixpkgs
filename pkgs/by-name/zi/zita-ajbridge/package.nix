{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  libjack2,
  zita-alsa-pcmi,
  zita-resampler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zita-ajbridge";
  version = "0.8.4";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-ajbridge-${finalAttrs.version}.tar.bz2";
    hash = "sha256-vCZONrpNcVw07H3W4xfNHtS7ikZWmA1rIgDi+gEFuzw=";
  };

  buildInputs = [
    alsa-lib
    libjack2
    zita-alsa-pcmi
    zita-resampler
  ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man/man1"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Connect additional ALSA devices to JACK";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.linux;
  };
})
