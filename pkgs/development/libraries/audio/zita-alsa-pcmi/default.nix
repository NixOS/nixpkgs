{ stdenv, fetchurl , alsaLib, }:

stdenv.mkDerivation rec {
  name = "zita-alsa-pcmi-${version}";
  version = "0.2.0";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "1rgv332g82rrrlm4vdam6p2pyrisxbi7b3izfaa0pcjglafsy7j9";
  };

  buildInputs = [ alsaLib ];

  buildPhase = ''
    cd libs
    make PREFIX="$out"

    # create lib link for building apps
    ln -s libzita-alsa-pcmi.so.$version libzita-alsa-pcmi.so

    # apps
    cd ../apps
    CXXFLAGS+=" -I../libs" \
    LDFLAGS+=" -L../libs" \
    make PREFIX="$out"
  '';

  installPhase = ''
    mkdir "$out"
    mkdir "$out/lib"
    mkdir "$out/include"
    mkdir "$out/bin"

    cd ../libs

    # libs
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
      "$out/bin/alsa_delay"
  '';

  meta = {
    description = "The successor of clalsadrv, provides easy access to ALSA PCM devices";
    version = "${version}";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
