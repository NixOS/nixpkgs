{stdenv, fetchurl, libnice, pkgconfig, python, glib, gstreamer, gstPluginsBase,
  pygobject, gst_python}:

stdenv.mkDerivation rec {
  name = "farsight2-0.0.22";
  
  src = fetchurl {
    url = "http://farsight.freedesktop.org/releases/farsight2/${name}.tar.gz";
    sha256 = "07yjndkx1p7ij1ifxsnbqbr8943wmq768x4812khka7dx6ii1sv9";
  };

  buildInputs = [ libnice pkgconfig python glib gstreamer gstPluginsBase 
    pygobject gst_python ];

  preBuild = ''
    sed -e '/^[[] -z/d' -i python/Makefile
    find . -name Makefile -execdir sed -e '/^[.]NOEXPORT:/d' -i '{}' ';'
    find . -name Makefile -execdir sed -r -e 's/^ {8,8}/\t/' -i '{}' ';'
  '';

  patches = [./makefile.patch];

  meta = {
    homepage = http://farsight.freedesktop.org/wiki/;
    description = "Audio/Video Communications Framework";
  };
}
