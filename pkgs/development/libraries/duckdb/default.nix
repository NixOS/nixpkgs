{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, substituteAll
, cmake
, ninja
, openssl
, openjdk11
, python3
, unixODBC
, withJdbc ? false
, withOdbc ? false
}:

let
  enableFeature = yes: if yes then "ON" else "OFF";
in
stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qGUq0iYTaLNHKqbXNLRmvqHMqunvIlP991IKb4qdSt4=";
  };

  patches = [
    # remove calls to git and set DUCKDB_VERSION to version
    (substituteAll {
      src = ./version.patch;
      version = "v${version}";
    })
    # add missing file needed for httpfs compile
    # remove on next update
    (fetchpatch {
      name = "missing-httpfs-file.patch";
      url = "https://github.com/duckdb/duckdb/commit/3d7aa3ed46ecf5f18122559e385b75f1f5e9aba8.patch";
      hash = "sha256-Q4IHCpMpxn86OquUZdEF7P0nHEPOcWS0TQijTkvBYbQ=";
    })
  ];

  nativeBuildInputs = [ cmake ninja python3 ];
  buildInputs = [ openssl ]
    ++ lib.optionals withJdbc [ openjdk11 ]
    ++ lib.optionals withOdbc [ unixODBC ];

  cmakeFlags = [
    "-DDUCKDB_EXTENSION_CONFIGS=${src}/.github/config/in_tree_extensions.cmake"
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
      excludes = map (pattern: "exclude:'${pattern}'") ([
        "[s3]"
        "Test closing database during long running query"
        "Test using a remote optimizer pass in case thats important to someone"
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
        "test/sql/json/table/read_json_objects.test"
        "test/sql/json/table/read_json.test"
        "test/sql/copy/parquet/parquet_5968.test"
        "test/fuzzer/pedro/buffer_manager_out_of_memory.test"
        "test/sql/storage/compression/bitpacking/bitpacking_size_calculation.test"
        "test/sql/copy/parquet/delta_byte_array_length_mismatch.test"
        "test/sql/function/timestamp/test_icu_strptime.test"
        "test/sql/timezone/test_icu_timezone.test"
        "test/sql/copy/parquet/snowflake_lineitem.test"
        "test/sql/copy/parquet/test_parquet_force_download.test"
        "test/sql/copy/parquet/delta_byte_array_multiple_pages.test"
        "test/sql/copy/csv/test_csv_httpfs_prepared.test"
        "test/sql/copy/csv/test_csv_httpfs.test"
        "test/sql/settings/test_disabled_file_system_httpfs.test"
        "test/sql/copy/csv/parallel/test_parallel_csv.test"
        "test/sql/copy/csv/parallel/csv_parallel_httpfs.test"
        "test/common/test_cast_struct.test"
        # test is order sensitive
        "test/sql/copy/parquet/parquet_glob.test"
        # these are only hidden if no filters are passed in
        "[!hide]"
        # this test apparently never terminates
        "test/sql/copy/csv/auto/test_csv_auto.test"
        # test expects installed file timestamp to be > 2024
        "test/sql/table_function/read_text_and_blob.test"
        # can re-enable next update (broken for 0.10.0)
        "test/sql/secrets/create_secret_non_writable_persistent_dir.test"
        # https://github.com/duckdb/duckdb/issues/10722
        "test/sql/types/nested/list/list_aggregate_dict.test"
      ] ++ lib.optionals stdenv.isAarch64 [
        "test/sql/aggregate/aggregates/test_kurtosis.test"
        "test/sql/aggregate/aggregates/test_skewness.test"
        "test/sql/function/list/aggregates/skewness.test"
      ]);
    in
    ''
      runHook preInstallCheck

      ./test/unittest ${toString excludes}

      runHook postInstallCheck
    '';

  meta = with lib; {
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${version}";
    description = "Embeddable SQL OLAP Database Management System";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    mainProgram = "duckdb";
    maintainers = with maintainers; [ costrouc cpcloud ];
    platforms = platforms.all;
  };
}
