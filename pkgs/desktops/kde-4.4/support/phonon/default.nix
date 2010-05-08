{ stdenv, fetchurl, cmake, qt4, automoc4, pkgconfig
, libXau, libXdmcp, libpthreadstubs
, gstreamer, gstPluginsBase, xineLib, pulseaudio}:

let
  v = "4.4.1";
  stable = true;
in

stdenv.mkDerivation rec {
  name = "phonon-${v}";
  src = fetchurl {
    url = "mirror://kde/${if stable then "" else "un"}stable/phonon/${v}/${name}.tar.bz2";
    sha256 = "0xsjbvpiqrsmqvxmhmjkwyhcxkajf1f78pg67kfwidaz9kkv0lla";
  };
  patches = [ ./phonon-4.4.1-gst-plugins-include.patch ];
  buildInputs = [ cmake qt4 libXau libXdmcp libpthreadstubs gstreamer
    gstPluginsBase xineLib automoc4 pulseaudio pkgconfig ];
  meta = with stdenv.lib; {
    platforms = platforms.linux;
    description = "KDE Multimedia API";
    longDescription = "KDE Multimedia API which abstracts over various backends such as GStreamer and Xine";
    license = "LGPL";
    homepage = http://phonon.kde.org;
    maintainers = [ maintainers.sander maintainers.urkud ];
  };
}
