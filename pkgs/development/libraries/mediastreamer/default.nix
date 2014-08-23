{ stdenv, fetchurl, pkgconfig, alsaLib, ffmpeg, speex, ortp, pulseaudio,
libv4l, libtheora, intltool, libvpx, gsm, mesa, libX11, libXv, libXext,
glew, libopus, libupnp, vim }:

stdenv.mkDerivation rec {
  name = "mediastreamer-2.10.0";

  src = fetchurl {
    url = "mirror://savannah/linphone/mediastreamer/${name}.tar.gz";
    sha256 = "1sp1vjcz0rx518l7cfmkb4802xa5wyylr2b5hxlpjk3ygg28g3c0";
  };

# TODO: make it load plugins from *_PLUGIN_PATH
  nativeBuildInputs = [pkgconfig intltool];

  propagatedBuildInputs = [ alsaLib ffmpeg speex ortp pulseaudio libX11
    libXv libXext libv4l libtheora libvpx gsm mesa glew libopus libupnp vim ];

  configureFlags = "--enable-external-ortp";
}
