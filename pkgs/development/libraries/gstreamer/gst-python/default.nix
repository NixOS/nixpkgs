{ fetchurl, stdenv, pkgconfig, python, gstreamer
  , gst_plugins_base, pygtk
}:

stdenv.mkDerivation rec {
  name = "gst-python-0.10.19";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "956f81a8c15daa3f17e688a0dc5a5d18a3118141066952d3b201a6ac0c52b415";
  };

  buildInputs =
    [ pkgconfig gst_plugins_base pygtk ]
    ;

  propagatedBuildInputs = [ gstreamer python ];
 
  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = "LGPLv2+";
  };
}

