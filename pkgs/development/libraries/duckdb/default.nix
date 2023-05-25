{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, openssl
, openjdk11
, unixODBC
, withJdbc ? false
, withOdbc ? false
}:

let
  enableFeature = yes: if yes then "ON" else "OFF";
in
stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dCPWrB/Jqm4/kS6J/3jcQG291tFKAZSEptEYLGOZsLo=";
  };

  patches = [ ./version.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --subst-var-by DUCKDB_VERSION "v${version}"
    substituteInPlace tools/shell/CMakeLists.txt \
      --replace \
      'install(TARGETS shell RUNTIME DESTINATION "''${PROJECT_BINARY_DIR}")' \
      'install(TARGETS shell RUNTIME DESTINATION "''${INSTALL_BIN_DIR}")'
  '';

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ openssl ]
    ++ lib.optionals withJdbc [ openjdk11 ]
    ++ lib.optionals withOdbc [ unixODBC ];

  cmakeFlags = [
    "-DBUILD_AUTOCOMPLETE_EXTENSION=ON"
    "-DBUILD_ICU_EXTENSION=ON"
    "-DBUILD_PARQUET_EXTENSION=ON"
    "-DBUILD_TPCH_EXTENSION=ON"
    "-DBUILD_TPCDS_EXTENSION=ON"
    "-DBUILD_FTS_EXTENSION=ON"
    "-DBUILD_HTTPFS_EXTENSION=ON"
    "-DBUILD_VISUALIZER_EXTENSION=ON"
    "-DBUILD_JSON_EXTENSION=ON"
    "-DBUILD_JEMALLOC_EXTENSION=ON"
    "-DBUILD_EXCEL_EXTENSION=ON"
    "-DBUILD_INET_EXTENSION=ON"
    "-DBUILD_TPCE=ON"
    "-DBUILD_ODBC_DRIVER=${enableFeature withOdbc}"
    "-DJDBC_DRIVER=${enableFeature withJdbc}"
  ] ++ lib.optionals doInstallCheck [
    # development settings
    "-DBUILD_UNITTESTS=ON"
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
        "test/sql/json/read_json_objects.test"
        "test/sql/json/read_json.test"
        "test/sql/copy/parquet/parquet_5968.test"
        "test/fuzzer/pedro/buffer_manager_out_of_memory.test"
        "test/sql/storage/compression/bitpacking/bitpacking_size_calculation.test"
        "test/sql/copy/parquet/delta_byte_array_length_mismatch.test"
        "test/sql/function/timestamp/test_icu_strptime.test"
        "test/sql/timezone/test_icu_timezone.test"
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

  meta = with lib; {
    homepage = "https://github.com/duckdb/duckdb";
    description = "Embeddable SQL OLAP Database Management System";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ costrouc cpcloud ];
  };
}
