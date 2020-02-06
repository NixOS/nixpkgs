{ stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost }:

stdenv.mkDerivation rec {
  pname = "libosmium";
  version = "2.15.4";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "0mlcvqrhp40bzj5r5j9nfc5vbis8hmzcq9xi8jylkciyydaynhz4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ protozero zlib bzip2 expat boost ];


  meta = with stdenv.lib; {
    description = "Fast and flexible C++ library for working with OpenStreetMap data";
    homepage = "https://osmcode.org/libosmium/";
    license = licenses.boost;
    maintainers = with maintainers; [ das-g ];
  };
}
