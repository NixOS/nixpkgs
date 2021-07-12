{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "cwida";
    repo = "duckdb";
    rev = "v${version}";
    sha256 = "0cnqq2n1424fqg7gfyvrwkk6nvjal2fm5n08xc8q28ynyhq4sfmj";
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
