{ stdenv, fetchurl, pcre, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "serd-${version}";
  version = "0.24.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0v3a9xss5ailrnb3flfjyl6l9pmp51dc02p0lr6phvwsipg8mywc";
  };

  buildInputs = [ pcre pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/serd;
    description = "A lightweight C library for RDF syntax which supports reading and writing Turtle and NTriples";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
