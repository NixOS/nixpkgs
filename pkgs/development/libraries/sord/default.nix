{ stdenv, fetchurl, pkgconfig, python, serd, pcre, wafHook }:

stdenv.mkDerivation rec {
  pname = "sord";
  version = "0.16.2";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "13fshxwpipjrvsah1m2jw1kf022z2q5vpw24bzcznglgvms13x89";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ python serd pcre ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/sord;
    description = "A lightweight C library for storing RDF data in memory";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
