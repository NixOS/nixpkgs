{ stdenv, fetchurl, pcre, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "serd-${version}";
  version = "0.14.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "023gsw0nwn2fh2vp7v2gwsmdwk6658zfl1ihdvr9xbayfcv88wlg";
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

  };
}
