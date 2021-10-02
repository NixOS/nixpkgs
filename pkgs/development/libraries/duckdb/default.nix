{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "cwida";
    repo = "duckdb";
    rev = "v${version}";
    sha256 = "sha256-ID65xpNSDyi19OcOs9Gdf5xpK++UVWclp8pVggIWQNU=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/cwida/duckdb";
    description = "Embeddable SQL OLAP Database Management System";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ costrouc ];
  };
}
