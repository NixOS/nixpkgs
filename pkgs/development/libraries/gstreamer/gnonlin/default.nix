{ stdenv, fetchurl, pkgconfig
, gst-plugins-base
}:

stdenv.mkDerivation rec {
  name = "gnonlin-1.4.0";

  meta = with stdenv.lib; {
    description = "Gstreamer Non-Linear Multimedia Editing Plugins";
    homepage    = "http://gstreamer.freedesktop.org";
    longDescription = ''
      Gnonlin is a library built on top of GStreamer which provides 
      support for writing non-linear audio and video editing
      applications. It introduces the concept of a timeline.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gnonlin/${name}.tar.xz";
    sha256 = "0zv60rq2h736a6fivd3a3wp59dj1jar7b2vwzykahvl168b7wrid";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gst-plugins-base ];
}
