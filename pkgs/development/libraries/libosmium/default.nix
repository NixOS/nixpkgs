{ lib, stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost, lz4 }:

stdenv.mkDerivation rec {
  pname = "libosmium";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "sha256-R7kOhQFfGYuHNkIZV4BTE+WKjHnCJwKeIWjCJNrvyTQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ protozero zlib bzip2 expat boost lz4 ];

  cmakeFlags = [ "-DINSTALL_GDALCPP:BOOL=ON" ];

  doCheck = true;

  meta = with lib; {
    description = "Fast and flexible C++ library for working with OpenStreetMap data";
    homepage = "https://osmcode.org/libosmium/";
    license = licenses.boost;
    changelog = [
      "https://github.com/osmcode/libosmium/releases/tag/v${version}"
      "https://github.com/osmcode/libosmium/blob/v${version}/CHANGELOG.md"
    ];
    maintainers = with maintainers; [ das-g ];
  };
}
