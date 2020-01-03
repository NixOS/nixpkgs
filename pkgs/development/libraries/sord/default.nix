{ stdenv, fetchurl, pkgconfig, python3, serd, pcre, wafHook }:

stdenv.mkDerivation rec {
  pname = "sord";
  version = "0.16.4";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "1mwh4qvp9q4vgrgg5bz9sgjhxscncrylf2b06h0q55ddwzs9hndi";
  };

  nativeBuildInputs = [ pkgconfig python3 wafHook ];
  buildInputs = [ serd pcre ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/sord;
    description = "A lightweight C library for storing RDF data in memory";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
