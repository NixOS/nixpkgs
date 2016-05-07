{ stdenv, fetchurl, pkgconfig, intltool, alsaLib, libpulseaudio, speex, gsm
, libopus, ffmpeg, libX11, libXv, mesa, glew, libtheora, libvpx, SDL, libupnp
, ortp, libv4l, libpcap, srtp, vim
}:

stdenv.mkDerivation rec {
  name = "mediastreamer-2.12.1";

  src = fetchurl {
    url = "mirror://savannah/linphone/mediastreamer/${name}.tar.gz";
    sha256 = "1rzjh2ln8qd6jvfmxlnbrcx2vbajx2j9hblqq2gdn10sf97qvgqd";
  };

  patches = [ ./plugins_dir.patch ];

  postPatch = ''
    sed -i "s/\(SRTP_LIBS=\"\$SRTP_LIBS -lsrtp\"\)/SRTP_LIBS=\"$(pkg-config --libs-only-l libsrtp)\"/g" configure
  '';

  nativeBuildInputs = [ pkgconfig intltool ];

  propagatedBuildInputs = [
    alsaLib libpulseaudio speex gsm libopus
    ffmpeg libX11 libXv mesa glew libtheora libvpx SDL libupnp
    ortp libv4l libpcap srtp
    vim
  ];

  configureFlags = [
    "--enable-external-ortp"
    "--with-srtp=${srtp}"
    "--enable-xv"
    "--enable-glx"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  meta = with stdenv.lib; {
    description = "a powerful and lightweight streaming engine specialized for voice/video telephony applications";
    homepage = http://www.linphone.org/technical-corner/mediastreamer2/overview;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
