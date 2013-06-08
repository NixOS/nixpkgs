{ stdenv, fetchurl, pkgconfig, alsaLib, ffmpeg, speex, ortp, pulseaudio, xorg,
  libv4l, libtheora, intltool, libvpx, gsm }:

stdenv.mkDerivation rec {
  name = "mediastreamer-2.8.2";

  src = fetchurl {
    url = "mirror://savannah/linphone/mediastreamer/${name}.tar.gz";
    sha256 = "0csg9a4mwfw5j475q9d5klhy82jnpcqfrlbvw81nxnqki40bnbm6";
  };

# TODO: make it load plugins from *_PLUGIN_PATH
  nativeBuildInputs = [pkgconfig intltool];

  propagatedBuildInputs = [alsaLib ffmpeg speex ortp pulseaudio xorg.libX11
    xorg.libXv xorg.libXext libv4l libtheora libvpx gsm ];

#patches = [ ./h264.patch ./plugins.patch ];

  configureFlags = "--enable-external-ortp";
}
