{ fetchurl, stdenv, cmake, ninja }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.4.8";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "0wi8yyynladny51r4q53z7ygh7y491ayp8nqqv6wqqzjc60s35hh";
  };

  nativeBuildInputs = [ cmake ninja ];

  meta = with stdenv.lib; {
    homepage = https://poppler.freedesktop.org/;
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = platforms.all;
    license = licenses.free; # more free licenses combined
    maintainers = with maintainers; [ ];
  };
}
