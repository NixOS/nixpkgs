{ stdenv, fetchurl, pkgconfig, librdf_raptor, ladspaH, openssl, zlib }:

stdenv.mkDerivation {
  name = "liblrdf-0.4.0";

  src = fetchurl {
    url = mirror://sourceforge/lrdf/liblrdf/0.4.0/liblrdf-0.4.0.tar.gz;
    sha256 = "015jv7pp0a0qxgljgdvf7d01nj4fx0zgzg0wayjp7v86pa38xscm";
  };

  buildInputs = [ pkgconfig ladspaH openssl zlib ];

  propagatedBuildInputs = [ librdf_raptor ];

  meta = { 
    description = "A lightweight RDF library with special support for LADSPA plugins.";
    homepage = http://sourceforge.net/projects/lrdf/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
