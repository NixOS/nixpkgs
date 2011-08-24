{ stdenv, fetchurl, pkgconfig, libtool, gtk ? null
, alsaLib, pulseaudio, gstreamer ? null, libvorbis, libcap }:

stdenv.mkDerivation rec {
  name = "libcanberra-0.28";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${name}.tar.gz";
    sha256 = "1346d2y24wiyanyr5bvdnjjgq7iysy8nlq2dwjv0fzxdmcn8n7zb";
  };

  buildInputs =
    [ pkgconfig libtool alsaLib pulseaudio gstreamer libvorbis libcap gtk ];

  configureFlags = "--disable-oss --disable-schemas-install";

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
