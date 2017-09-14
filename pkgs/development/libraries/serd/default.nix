{ stdenv, fetchurl, pcre, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "serd-${version}";
  version = "0.26.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "164j43am4hka2vbzw4n52zy7rafgp6kmkgbcbvap368az644mr73";
  };

  buildInputs = [ pcre pkgconfig python ];

  configurePhase = "${python.interpreter} waf configure --prefix=$out";

  buildPhase = "${python.interpreter} waf";

  installPhase = "${python.interpreter} waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/serd;
    description = "A lightweight C library for RDF syntax which supports reading and writing Turtle and NTriples";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
