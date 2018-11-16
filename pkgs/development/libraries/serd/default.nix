{ stdenv, fetchurl, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "serd-${version}";
  version = "0.30.0";

  src = fetchurl {
    url = "https://download.drobilla.net/${name}.tar.bz2";
    sha256 = "1yyfyvc6kwagi5w43ljp1bbjdvdpmgpds74lmjxycm91bkx0xyvf";
  };

  nativeBuildInputs = [ pkgconfig python ];

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
