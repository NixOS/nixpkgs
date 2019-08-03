{ stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost }:

stdenv.mkDerivation rec {
  name = "libosmium-${version}";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "1v1m068lcjngxnwirpi0vqjhqnxn9gqvafjp3sy14vzmgl2sw2kr";
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
