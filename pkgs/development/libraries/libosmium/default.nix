{ lib, stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost, lz4 }:

stdenv.mkDerivation rec {
  pname = "libosmium";
  version = "2.17.3";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "sha256-XpC5gb19jPakYS3QSgOU6WnGad+VEoEtxyT38d9Beug=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ protozero zlib bzip2 expat boost lz4 ];

  cmakeFlags = [ "-DINSTALL_GDALCPP:BOOL=ON" ];

  doCheck = true;

  meta = with lib; {
    description = "Fast and flexible C++ library for working with OpenStreetMap data";
    homepage = "https://osmcode.org/libosmium/";
    license = licenses.boost;
    maintainers = with maintainers; [ das-g ];
  };
}
