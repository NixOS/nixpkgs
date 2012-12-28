{ stdenv, fetchurl, pkgconfig, alsaLib, ffmpeg, speex, ortp, pulseaudio, xorg,
  libv4l, libtheora, intltool, libvpx, gsm }:

stdenv.mkDerivation rec {
  name = "mediastreamer-2.8.0";

  src = fetchurl {
    url = "mirror://savannah/linphone/mediastreamer/${name}.tar.gz";
    sha256 = "0h1qda2mjc76xirldlvpmzf57vcbgr113a9b0kw1xm5i58s0w34f";
  };

# TODO: make it load plugins from *_PLUGIN_PATH
  nativeBuildInputs = [pkgconfig intltool];

  propagatedBuildInputs = [alsaLib ffmpeg speex ortp pulseaudio xorg.libX11
    xorg.libXv xorg.libXext libv4l libtheora libvpx gsm ];

#patches = [ ./h264.patch ./plugins.patch ];

  configureFlags = "--enable-external-ortp";
}
