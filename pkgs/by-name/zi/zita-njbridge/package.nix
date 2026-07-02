{
  lib,
  stdenv,
  fetchurl,
  libjack2,
  zita-resampler,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.4.8";
  pname = "zita-njbridge";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-njbridge-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-EBF2oL1AfKt7/9Mm6NaIbBtlshK8M/LvuXsD+SbEeQc=";
  };

  buildInputs = [
    libjack2
    zita-resampler
  ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)"
    "SUFFIX=''"
  ];

  meta = {
    description = "Command line Jack clients to transmit full quality multichannel audio over a local IP network";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
