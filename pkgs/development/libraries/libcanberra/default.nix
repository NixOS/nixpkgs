{ stdenv, fetchurl, pkgconfig, libtool, gtk ? null
, alsaLib, pulseaudio, gstreamer, gst_plugins_base, libvorbis }:

stdenv.mkDerivation rec {
  name = "libcanberra-0.30";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${name}.tar.xz";
    sha256 = "0wps39h8rx2b00vyvkia5j40fkak3dpipp1kzilqla0cgvk73dn2";
  };

  buildInputs = # ToDo: gstreamer not found (why?), add (g)udev?
    [ pkgconfig libtool alsaLib pulseaudio /*gstreamer gst_plugins_base*/ libvorbis gtk ];

  configureFlags = "--disable-oss";

  meta = {
    description = "An implementation of the XDG Sound Theme and Name Specifications";

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
