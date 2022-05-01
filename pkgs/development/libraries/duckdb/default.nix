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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2PBc5qe2md87u2nvMTx/XZVzLsr8QrvUkw46/6VTlGs=";
  };

  patches = [ ./version.patch ];
  postPatch = ''
    substituteInPlace CMakeLists.txt --subst-var-by DUCKDB_VERSION "v${version}"
  '';

  cmakeFlags = [
    "-DBUILD_EXCEL_EXTENSION=ON"
    "-DBUILD_FTS_EXTENSION=ON"
    "-DBUILD_HTTPFS_EXTENSION=${enableFeature withHttpFs}"
    "-DBUILD_ICU_EXTENSION=ON"
    "-DBUILD_JSON_EXTENSION=ON"
    "-DBUILD_ODBC_DRIVER=${enableFeature withOdbc}"
    "-DBUILD_PARQUET_EXTENSION=ON"
    "-DBUILD_REST=ON"
    "-DBUILD_SUBSTRAIT_EXTENSION=ON"
    "-DBUILD_TPCDS_EXTENSION=ON"
    "-DBUILD_TPCE=ON"
    "-DBUILD_TPCH_EXTENSION=ON"
    "-DBUILD_VISUALIZER_EXTENSION=ON"
    "-DJDBC_DRIVER=${enableFeature withJdbc}"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $PWD/test/unittest \
      'exclude:[test_slow]' \
      'exclude:*test_slow' \
      exclude:test/sql/copy/csv/test_csv_remote.test \
      exclude:test/sql/copy/parquet/test_parquet_remote.test \
      exclude:test/common/test_cast_hugeint.test \
      exclude:'Test file buffers for reading/writing to file'

    runHook postInstallCheck
  '';

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
