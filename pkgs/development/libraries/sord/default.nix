{ stdenv, fetchurl, pkgconfig, python, serd, pcre }:

stdenv.mkDerivation rec {
  name = "sord-${version}";
  version = "0.16.2";

  src = fetchurl {
    url = "https://download.drobilla.net/${name}.tar.bz2";
    sha256 = "13fshxwpipjrvsah1m2jw1kf022z2q5vpw24bzcznglgvms13x89";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python serd pcre ];

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
