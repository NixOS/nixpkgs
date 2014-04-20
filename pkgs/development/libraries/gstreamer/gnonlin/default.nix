{ stdenv, fetchurl, pkgconfig
, gst-plugins-base
}:

stdenv.mkDerivation rec {
  name = "gnonlin-1.2.0";

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
    sha256 = "15hyb0kg8sm92kj37cir4l3sa21b8zy4la1ccfhb358b4mf24vl7";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gst-plugins-base ];
}
