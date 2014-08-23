{ stdenv, fetchurl, pkgconfig
, gst-plugins-base
}:

stdenv.mkDerivation rec {
  name = "gnonlin-1.2.1";

  meta = with stdenv.lib; {
    description = "Gstreamer Non-Linear Multimedia Editing Plugins";
    homepage    = "http://gstreamer.freedesktop.org";
    longDescription = ''
      Gnonlin is a library built on top of GStreamer which provides 
      support for writing non-linear audio and video editing
      applications. It introduces the concept of a timeline.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gnonlin/${name}.tar.xz";
    sha256 = "14zb3bz3xn40a2kns719amrr77cp6wyxddml621kyxc424ihcw3q";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gst-plugins-base ];
}
