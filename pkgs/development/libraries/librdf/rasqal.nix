{ stdenv, fetchurl, librdf_raptor2, gmp, pkgconfig, pcre, libxml2, perl }:

stdenv.mkDerivation rec {
  name = "rasqal-0.9.33";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "0z6rrwn4jsagvarg8d5zf0j352kjgi33py39jqd29gbhcnncj939";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gmp pcre libxml2 ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  checkInputs = [ perl ];
  doCheck = false; # fails with "No testsuite plan file sparql-query-plan.ttl could be created in build/..."
  doInstallCheck = false; # fails with "rasqal-config does not support (--help|--version)"

  meta = {
    description = "Library that handles Resource Description Framework (RDF)";
    homepage = "http://librdf.org/rasqal";
    license = with stdenv.lib.licenses; [ lgpl21 asl20 ];
    maintainers = with stdenv.lib.maintainers; [ marcweber ];
    platforms = stdenv.lib.platforms.unix;
  };
}
