{ stdenv, fetchurl, pkgconfig, libtool, gtk
, alsaLib, pulseaudio, gstreamer, libvorbis, libcap }:

stdenv.mkDerivation rec {
  name = "libcanberra-0.23";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${name}.tar.gz";
    sha256 = "0q09gasvm5dc9d4640lzb5nnmy2cpyi74aq83kjd3j4z58lczl57";
  };

  buildInputs =
    [ pkgconfig libtool alsaLib pulseaudio gstreamer libvorbis libcap ];
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

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
