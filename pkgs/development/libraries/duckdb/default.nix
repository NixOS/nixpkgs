{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "cwida";
    repo = "duckdb";
    rev = "v${version}";
    sha256 = "sha256-X8zk9D7BQQ6iHdfvpaTZ8wS779wt3nRthH7OG4p9bTg=";
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
