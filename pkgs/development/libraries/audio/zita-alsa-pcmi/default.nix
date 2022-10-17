{ lib, stdenv, fetchurl , alsa-lib, }:

stdenv.mkDerivation rec {
  pname = "zita-alsa-pcmi";
  version = "0.5.1";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-zyAKaO22She1e/+zPjiwSHeCctGLVYnT0vWgHODzSwc=";
  };

  buildInputs = [ alsa-lib ];

  buildPhase = ''
    cd source
    make PREFIX="$out"

    # create lib link for building apps
    ln -s libzita-alsa-pcmi.so.$version libzita-alsa-pcmi.so

    # apps
    cd ../apps
    CXXFLAGS+=" -I../source" \
    LDFLAGS+=" -L../source" \
    make PREFIX="$out"
  '';

  installPhase = ''
    mkdir "$out"
    mkdir "$out/lib"
    mkdir "$out/include"
    mkdir "$out/bin"

    cd ../source

    # source
    install -Dm755 libzita-alsa-pcmi.so.$version \
      "$out/lib/libzita-alsa-pcmi.so.$version"

    # link
    ln -s libzita-alsa-pcmi.so.$version \
      "$out/lib/libzita-alsa-pcmi.so"
    ln -s libzita-alsa-pcmi.so.$version \
      "$out/lib/libzita-alsa-pcmi.so.0"

    # header
    install -Dm644 zita-alsa-pcmi.h \
      "$out/include/zita-alsa-pcmi.h"

    # apps
    install -Dm755 ../apps/alsa_delay \
      "$out/bin/alsa_delay"
    install -Dm755 ../apps/alsa_loopback \
      "$out/bin/alsa_loopback"
  '';

  meta = {
    description = "The successor of clalsadrv, provides easy access to ALSA PCM devices";
    version = version;
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
