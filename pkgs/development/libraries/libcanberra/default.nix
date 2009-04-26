{ stdenv, fetchurl, pkgconfig, libtool, gtk, gthread
, alsaLib, pulseaudio, gstreamer, libvorbis }:

stdenv.mkDerivation rec {
  name = "libcanberra-0.10";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${name}.tar.gz";
    sha256 = "0wl2hd8zqwzbbp4icng6siim85jb6hvczy9c6m92lh85wrcwpqxh";
  };

  buildInputs = [ pkgconfig libtool alsaLib pulseaudio gstreamer libvorbis ];
  propagatedBuildInputs = [ gtk ];

  configureFlags = "--disable-oss";

  meta = {
    description = "libcanberra, an implementation of the XDG Sound Theme and Name Specifications";

    longDescription = ''
      libcanberra is an implementation of the XDG Sound Theme and Name
      Specifications, for generating event sounds on free desktops
      such as GNOME.  It comes with several backends (ALSA,
      PulseAudio, OSS, GStreamer, null) and is designed to be
      portable.
    '';

    homepage = http://0pointer.de/lennart/projects/libcanberra/;

    license = "LGPLv2+";
  };
}
