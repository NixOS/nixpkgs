{ stdenv, fetchurl, pkgconfig, intltool, alsaLib, libpulseaudio, speex, gsm
, libopus, ffmpeg, libX11, libXv, mesa, glew, libtheora, libvpx, SDL, libupnp
, ortp, libv4l, libpcap, srtp, fetchFromGitHub, cmake, bctoolbox, doxygen
, python, libXext, libmatroska, openssl
}:

stdenv.mkDerivation rec {
  baseName = "mediastreamer2";
  version = "2.14.0";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "1b59rzsaw54mhy4pz9hndmim4rgidkn7s6c4iyl34mz58lwxpmqp";
  };

  patches = [ ./plugins_dir.patch ];

  nativeBuildInputs = [ pkgconfig intltool cmake doxygen python ];

  propagatedBuildInputs = [
    alsaLib libpulseaudio speex gsm libopus
    ffmpeg libX11 libXv mesa glew libtheora libvpx SDL libupnp
    ortp libv4l libpcap srtp bctoolbox libXext libmatroska
    openssl
  ];

  NIX_CFLAGS_COMPILE = " -DGIT_VERSION=\"v2.14.0\" -Wno-error=deprecated-declarations ";
  NIX_LDFLAGS = " -lXext -lssl ";

  meta = with stdenv.lib; {
    description = "A powerful and lightweight streaming engine specialized for voice/video telephony applications";
    homepage = http://www.linphone.org/technical-corner/mediastreamer2/overview;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
