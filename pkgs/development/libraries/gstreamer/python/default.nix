{ fetchurl, stdenv, pkgconfig, python, gstreamer
  , gst-plugins-base, pygtk, pygobject3
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.2.0";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "09c6yls8ipbmwimdjr7xi3hvf2xa1xn1pv07855r7wfyzas1xbl1";
  };

  buildInputs =
    [ pkgconfig gst-plugins-base pygtk pygobject3 ]
    ;

  preConfigure = ''
    export configureFlags="$configureFlags --with-pygi-overrides-dir=$out/lib/${python.libPrefix}/site-packages/gi/overrides"
  '';

  propagatedBuildInputs = [ gstreamer python ];
 
  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = "LGPLv2+";
  };
}

