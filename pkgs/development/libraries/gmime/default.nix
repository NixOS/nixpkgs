{ stdenv, fetchurl, pkgconfig, glib, zlib }:

stdenv.mkDerivation rec {
  name = "gmime-2.4.24";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.4/${name}.tar.gz";
    sha256 = "2f538d68e215f075d16575a6da9acb87983db9e2df0d7d403858048881a0dd15";
  };
  
  buildInputs = [ pkgconfig glib zlib ];

  meta = {
    homepage = http://spruce.sourceforge.net/gmime/;
    description = "A C/C++ library for manipulating MIME messages";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
