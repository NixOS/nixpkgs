{ stdenv, fetchurl, librdf_raptor2, gmp, pkgconfig, pcre, libxml2 }:

stdenv.mkDerivation rec {
  name = "rasqal-0.9.31";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "1vkzifr488i31vxdnykyf2aq87023vx4bag4d94b1rdhy74l7mr8";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gmp pcre libxml2 ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  meta = {
    description = "Library that handles Resource Description Framework (RDF)";
    homepage = "http://librdf.org/rasqal";
    license = "LGPL-2.1 Apache-2.0";
    maintainers = with stdenv.lib.maintainers; [ marcweber urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
