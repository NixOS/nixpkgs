{ stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost }:

stdenv.mkDerivation rec {
  name = "libosmium-${version}";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "0s51qk7py5dzr07q4a78b4mjjrpgbghnj2r8yjq1hnn6pgafbjv0";
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
