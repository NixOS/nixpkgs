{ lib
, stdenv
, fetchFromGitHub
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
  versions = lib.importJSON ./versions.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "duckdb";
  inherit (versions) rev version;

  src = fetchFromGitHub {
    # to update run:
    # nix-shell maintainers/scripts/update.nix --argstr path duckdb
    inherit (versions) hash;
    owner = "duckdb";
    repo = "duckdb";
    rev = "refs/tags/v${finalAttrs.version}";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ cmake ninja python3 ];
  buildInputs = [ openssl ]
    ++ lib.optionals withJdbc [ openjdk11 ]
    ++ lib.optionals withOdbc [ unixODBC ];

  cmakeFlags = [
    "-DDUCKDB_EXTENSION_CONFIGS=${finalAttrs.src}/.github/config/in_tree_extensions.cmake"
    "-DBUILD_ODBC_DRIVER=${enableFeature withOdbc}"
    "-DJDBC_DRIVER=${enableFeature withJdbc}"
    "-DOVERRIDE_GIT_DESCRIBE=v${finalAttrs.version}-0-g${finalAttrs.rev}"
  ] ++ lib.optionals finalAttrs.doInstallCheck [
    # development settings
    "-DBUILD_UNITTESTS=ON"
  ];

  postInstall = ''
    mkdir -p $lib
    mv $out/lib $lib
  '';

  doInstallCheck = true;

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
        # fails with Out of Memory Error
        "test/sql/copy/parquet/batched_write/batch_memory_usage.test"
        # wants http connection
        "test/sql/copy/csv/recursive_query_csv.test"
        "test/sql/copy/csv/test_mixed_lines.test"
      ] ++ lib.optionals stdenv.isAarch64 [
        "test/sql/aggregate/aggregates/test_kurtosis.test"
        "test/sql/aggregate/aggregates/test_skewness.test"
        "test/sql/function/list/aggregates/skewness.test"
      ]);
      LD_LIBRARY_PATH = lib.optionalString stdenv.isDarwin "DY" + "LD_LIBRARY_PATH";
    in
    ''
      runHook preInstallCheck
      (($(ulimit -n) < 1024)) && ulimit -n 1024

      HOME="$(mktemp -d)" ${LD_LIBRARY_PATH}="$lib/lib" ./test/unittest ${toString excludes}

      runHook postInstallCheck
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${finalAttrs.version}";
    description = "Embeddable SQL OLAP Database Management System";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    mainProgram = "duckdb";
    maintainers = with maintainers; [ costrouc cpcloud ];
    platforms = platforms.all;
  };
})
