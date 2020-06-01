{ stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost }:

stdenv.mkDerivation rec {
  pname = "libosmium";
  version = "2.15.5";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "1f21dzzkxzi74hv17fs9kb2w6indqvvm4lkxclz4j4x98k8q3n59";
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
