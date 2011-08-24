{ stdenv, fetchurl, pkgconfig, alsaLib, ffmpeg, speex, ortp, pulseaudio, xorg,
  libv4l, libtheora }:

stdenv.mkDerivation rec {
  name = "mediastreamer-2.7.2";

  src = fetchurl {
    url = "mirror://savannah/linphone/mediastreamer/${name}.tar.gz";
    sha256 = "1w5j5shzd5f7q3l2gm4cl82f3vnrdzp78lcyjbjb416c4vzw2nr2";
  };

# TODO: make it load plugins from *_PLUGIN_PATH
  buildNativeInputs = [pkgconfig];

  propagatedBuildInputs = [alsaLib ffmpeg speex ortp pulseaudio xorg.libX11
    xorg.libXv xorg.libXext libv4l libtheora];

#patches = [ ./h264.patch ./plugins.patch ];

  configureFlags = "--enable-external-ortp";
}
