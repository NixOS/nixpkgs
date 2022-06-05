{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "h3";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "uber";
    repo = "h3";
    rev = "v${version}";
    sha256 = "sha256-MvWqQraTnab6EuDx4V0v8EvrFWHT95f2EHTL2p2kei8=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_LINTING=OFF"
  ];

  meta = with lib; {
    homepage = "https://h3geo.org/";
    description = "Hexagonal hierarchical geospatial indexing system";
    license = licenses.asl20;
    changelog = "https://github.com/uber/h3/raw/v${version}/CHANGELOG.md";
    platforms = platforms.all;
    maintainers = [ maintainers.kalbasit ];
  };
}
