{ stdenv, fetchsvn, pkgconfig, python, serd }:

stdenv.mkDerivation rec {
  name = "sord-svn-${rev}";
  rev = "327";

  src = fetchsvn {
    url = "http://svn.drobilla.net/sord/trunk";
    rev = rev;
    sha256 = "09lf6xmwfg8kbmz1b7d3hrpz0qqr8prdjqrp91aw70cgclx2pwc4";
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
