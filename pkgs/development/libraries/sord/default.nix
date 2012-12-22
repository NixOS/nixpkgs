{ stdenv, fetchurl, pkgconfig, python, serd }:

stdenv.mkDerivation rec {
  name = "sord-${version}";
  version = "0.8.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0ncaplfr3wal9h8h3lafw0bhx34w046r7md74djgrysrm2h77pwr";
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

  };
}
