{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "cwida";
    repo = "duckdb";
    rev = "v${version}";
    sha256 = "15qn967q9v23l0sgb2jqb77z4qdkyn1zwdpj4b0rd9zk5h3fzj55";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/cwida/duckdb";
    description = "DuckDB is an embeddable SQL OLAP Database Management System";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ costrouc ];
  };
}
