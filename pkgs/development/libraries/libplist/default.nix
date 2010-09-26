{ stdenv, fetchurl, cmake, libxml2, glib, swig, python }:

stdenv.mkDerivation rec {
  name = "libplist-1.3";

  buildInputs = [ cmake swig ];

  patches = [ ./swig.patch ];

  propagatedBuildInputs = [ libxml2 glib python ];

  src = fetchurl {
    url = "http://github.com/downloads/JonathanBeck/libplist/${name}.tar.bz2";
    sha256 = "1c5nwp9jbsp5kx8avmmsr5g7qdngnqlplh2sjbygmhydb6n8lb4q";
  };

  meta = {
    homepage = http://github.com/JonathanBeck/libplist;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
