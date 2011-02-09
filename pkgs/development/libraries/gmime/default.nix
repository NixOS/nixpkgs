{ stdenv, fetchurl, pkgconfig, glib, zlib }:

stdenv.mkDerivation rec {
  name = "gmime-2.4.22";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.4/${name}.tar.gz";
    sha256 = "0s93amrj7fh3p8lv770p7mrml07m6dps6srwi1wn76d2rfb944xn";
  };
  
  buildInputs = [ pkgconfig glib zlib ];

  meta = {
    homepage = http://spruce.sourceforge.net/gmime/;
    description = "A C/C++ library for manipulating MIME messages";
  };
}
