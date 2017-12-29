{ stdenv, fetchurl, pkgconfig, python, serd }:

stdenv.mkDerivation rec {
  name = "sord-${version}";
  version = "0.16.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0nh3i867g9z4kdlnk82cg2kcw8r02qgifxvkycvzb4vfjv4v4g4x";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python serd ];

  configurePhase = "${python.interpreter} waf configure --prefix=$out";

  buildPhase = "${python.interpreter} waf";

  installPhase = "${python.interpreter} waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/sord;
    description = "A lightweight C library for storing RDF data in memory";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
