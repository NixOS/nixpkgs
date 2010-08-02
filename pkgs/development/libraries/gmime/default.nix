{ stdenv, fetchurl, pkgconfig, glib, zlib }:

stdenv.mkDerivation rec {
  name = "gmime-2.4.17";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.4/${name}.tar.gz";
    sha256 = "1l1pbk0yrr7zwl90aabdhw0f9i4m6ragsfyk5qwg0hzk21abz9wd";
  };
  
  buildInputs = [ pkgconfig glib zlib ];

  meta = {
    homepage = http://spruce.sourceforge.net/gmime/;
    description = "A C/C++ library for manipulating MIME messages";
  };
}
