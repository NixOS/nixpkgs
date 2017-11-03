{ stdenv, fetchurl, librdf_raptor2, gmp, pkgconfig, pcre, libxml2 }:

stdenv.mkDerivation rec {
  name = "rasqal-0.9.32";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "eeba03218e3b7dfa033934d523a1a64671a9a0f64eadc38a01e4b43367be2e8f";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gmp pcre libxml2 ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  meta = {
    description = "Library that handles Resource Description Framework (RDF)";
    homepage = http://librdf.org/rasqal;
    license = with stdenv.lib.licenses; [ lgpl21 asl20 ];
    maintainers = with stdenv.lib.maintainers; [ marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
