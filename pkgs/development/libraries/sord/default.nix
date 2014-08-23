{ stdenv, fetchurl, pkgconfig, python, serd }:

stdenv.mkDerivation rec {
  name = "sord-${version}";
  version = "0.12.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "1f0wz7ynnk72hyr4jfi0lgvj90ld2va1kig8fkw30s8b903alsqj";
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
