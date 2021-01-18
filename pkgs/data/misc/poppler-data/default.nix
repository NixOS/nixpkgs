{ fetchurl, lib, stdenv, cmake, ninja }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.4.10";

  src = fetchurl {
    url = "https://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "0c3vjs3p7rjc4yfacnhd865r27czmzwcr4j2z4jldi68dvvcwbvf";
  };

  nativeBuildInputs = [ cmake ninja ];

  meta = with lib; {
    homepage = "https://poppler.freedesktop.org/";
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = platforms.all;
    license = licenses.free; # more free licenses combined
    maintainers = with maintainers; [ ];
  };
}
