{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-no4fcukEpzKmh2i41sdXGDljGhEDkzk3rYBATqlq6Gw=";
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
    "-DBUILD_TPCDS_EXTENSION=ON"
    "-DBUILD_TPCE=ON"
    "-DBUILD_TPCH_EXTENSION=ON"
    "-DBUILD_VISUALIZER_EXTENSION=ON"
    "-DBUILD_INET_EXTENSION=ON"
    "-DJDBC_DRIVER=${enableFeature withJdbc}"
  ];

  doInstallCheck = true;

  preInstallCheck = ''
    export HOME="$(mktemp -d)"
  '' + lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="$out/lib''${DYLD_LIBRARY_PATH:+:}''${DYLD_LIBRARY_PATH}"
  '';

  installCheckPhase =
    let
      excludes = map (pattern: "exclude:'${pattern}'") [
        "[s3]"
        "Test closing database during long running query"
        "test/common/test_cast_hugeint.test"
        "test/sql/copy/csv/test_csv_remote.test"
        "test/sql/copy/parquet/test_parquet_remote.test"
        "test/sql/copy/parquet/test_parquet_remote_foreign_files.test"
        "test/sql/storage/compression/chimp/chimp_read.test"
        "test/sql/storage/compression/chimp/chimp_read_float.test"
        "test/sql/storage/compression/patas/patas_compression_ratio.test_coverage"
        "test/sql/storage/compression/patas/patas_read.test"
        # these are only hidden if no filters are passed in
        "[!hide]"
        # this test apparently never terminates
        "test/sql/copy/csv/auto/test_csv_auto.test"
      ] ++ lib.optionals stdenv.isAarch64 [
        "test/sql/aggregate/aggregates/test_kurtosis.test"
        "test/sql/aggregate/aggregates/test_skewness.test"
        "test/sql/function/list/aggregates/skewness.test"
      ];
    in
    ''
      runHook preInstallCheck

      $PWD/test/unittest ${lib.concatStringsSep " " excludes}

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
