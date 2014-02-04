{ fetchurl, stdenv, pkgconfig, python, gstreamer
  , gst-plugins-base, pygtk, pygobject3
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.1.90";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1vsykx2l5360y19c0rxspa9nf1ilml2c1ybsv8cw8p696scryb2l";
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

