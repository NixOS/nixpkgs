{ stdenv, fetchurl, pkgconfig, python, serd }:

stdenv.mkDerivation rec {
  name = "sord-${version}";
  version = "0.12.2";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0rq7vafdv4vsxi6xk9zf5shr59w3kppdhqbj78185rz5gp9kh1dx";
  };

  buildInputs = [ pkgconfig python serd ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/sord;
    description = "A lightweight C library for storing RDF data in memory";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
