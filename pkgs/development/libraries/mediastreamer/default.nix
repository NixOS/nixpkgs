{ stdenv, fetchurl, pkgconfig, intltool, alsaLib, pulseaudio, speex, gsm
, libopus, ffmpeg, libX11, libXv, mesa, glew, libtheora, libvpx, SDL, libupnp
, ortp, libv4l, libpcap, srtp, vim
}:

stdenv.mkDerivation rec {
  name = "mediastreamer-2.11.1";

  src = fetchurl {
    url = "mirror://savannah/linphone/mediastreamer/${name}.tar.gz";
    sha256 = "0gfv4k2rsyvyq838xjgsrxmmn0fkw40apqs8vakzjwzsz2c9z8pd";
  };

  postPatch = ''
    sed -i "s/\(SRTP_LIBS=\"\$SRTP_LIBS -lsrtp\"\)/SRTP_LIBS=\"$(pkg-config --libs-only-l libsrtp)\"/g" configure
  '';

  # TODO: make it load plugins from *_PLUGIN_PATH
  nativeBuildInputs = [ pkgconfig intltool ];

  propagatedBuildInputs = [
    alsaLib pulseaudio speex gsm libopus
    ffmpeg libX11 libXv mesa glew libtheora libvpx SDL libupnp
    ortp libv4l libpcap srtp
    vim
  ];

  configureFlags = [
    "--enable-external-ortp"
    "--with-srtp=${srtp}"
  ];

  meta = with stdenv.lib; {
    description = "a powerful and lightweight streaming engine specialized for voice/video telephony applications";
    homepage = http://www.linphone.org/technical-corner/mediastreamer2/overview;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
