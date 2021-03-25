{ lib, stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost }:

stdenv.mkDerivation rec {
  pname = "libosmium";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "1na51g6xfm1bx0d0izbg99cwmqn0grp0g41znn93xnhs202qnb2h";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ protozero zlib bzip2 expat boost ];

  cmakeFlags = [ "-DINSTALL_GDALCPP:BOOL=ON" ];

  doCheck = true;

  meta = with lib; {
    description = "Fast and flexible C++ library for working with OpenStreetMap data";
    homepage = "https://osmcode.org/libosmium/";
    license = licenses.boost;
    maintainers = with maintainers; [ das-g ];
  };
}
