{ stdenv, fetchurl, librdf_raptor, gmp, pkgconfig, pcre, libxml2 }:

stdenv.mkDerivation rec {
  name = "rasqal-0.9.19";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "a042846e8b7af52d9d66fba788c9d579e58c535cfaf80d33dc0bd69bf6ffeb08";
  };

  buildInputs = [ librdf_raptor gmp /*or mpfr*/ pkgconfig pcre libxml2 ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lraptor"
  '';

  meta = { 
    description = "Library that handles Resource Description Framework (RDF)";
    homepage = "http://librdf.org/rasqal";
    license = "LGPL-2.1 Apache-2.0";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
