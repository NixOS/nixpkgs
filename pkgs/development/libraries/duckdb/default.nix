{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cwida";
    repo = "duckdb";
    rev = "v${version}";
    sha256 = "18l4qdzfm8k9ggn49r3h99cbcmmq01byzkxps3pvmq8q246hb55x";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/cwida/duckdb";
    description = "Embeddable SQL OLAP Database Management System";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ costrouc ];
  };
}
