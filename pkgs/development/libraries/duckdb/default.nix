{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, openssl
, openjdk11
, unixODBC
, withHttpFs ? true
, withJdbc ? false
, withOdbc ? false
}:

let
  enableFeature = yes: if yes then "ON" else "OFF";
in
stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WxJj5hOJsRuKUHjpGZWsa0PxRZZJcX88p1/typ+yqEw=";
  };

  patches = [ ./version.patch ];
  postPatch = ''
    substituteInPlace CMakeLists.txt --subst-var-by DUCKDB_VERSION "v${version}"
  '';

  cmakeFlags = [
    "-DBUILD_FTS_EXTENSION=ON"
    "-DBUILD_HTTPFS_EXTENSION=${enableFeature withHttpFs}"
    "-DBUILD_ICU_EXTENSION=ON"
    "-DBUILD_ODBC_DRIVER=${enableFeature withOdbc}"
    "-DBUILD_PARQUET_EXTENSION=ON"
    "-DBUILD_REST_EXTENSION=ON"
    "-DBUILD_TPCDS_EXTENSION=ON"
    "-DBUILD_TPCH_EXTENSION=ON"
    "-DBUILD_VISUALIZER_EXTENSION=ON"
    "-DJDBC_DRIVER=${enableFeature withJdbc}"
  ];

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = lib.optionals withHttpFs [ openssl ]
    ++ lib.optionals withJdbc [ openjdk11 ]
    ++ lib.optionals withOdbc [ unixODBC ];

  meta = with lib; {
    homepage = "https://github.com/duckdb/duckdb";
    description = "Embeddable SQL OLAP Database Management System";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ costrouc cpcloud ];
  };
}
