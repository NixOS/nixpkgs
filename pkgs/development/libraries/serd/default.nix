{ stdenv, fetchurl, pkgconfig, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "serd";
  version = "0.30.4";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "168rn3m32c59qbar120f83ibcnnd987ij9p053kybgl7cmm6358c";
  };

  nativeBuildInputs = [ pkgconfig python3 wafHook ];

  meta = with stdenv.lib; {
    homepage = "http://drobilla.net/software/serd";
    description = "A lightweight C library for RDF syntax which supports reading and writing Turtle and NTriples";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
