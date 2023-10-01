{ lib
, stdenv
, fetchFromGitHub
, cmake
, git
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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    leaveDotGit = true;
    rev = "v${version}";
    hash = "sha256-NFkeeTpsxazQOstKUUu0b27hXbnq3U5g/+24BIMqtJY=";
  };

  patches = [ ./version.patch ];

  nativeBuildInputs = [ cmake git ninja ];
  buildInputs = [ openssl ]
    ++ lib.optionals withJdbc [ openjdk11 ]
    ++ lib.optionals withOdbc [ unixODBC ];

  cmakeFlags = [
    # use similar flags to what is defined in ${src}/.github/workflow/{LinuxRelease,OSX}.yml
    "-DDUCKDB_EXTENSION_CONFIGS=${src}/.github/config/bundled_extensions.cmake"
    "-DGIT_LAST_TAG=${src.rev}"
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
        "test/fuzzer/pedro/buffer_manager_out_of_memory.test"
        "test/sql/copy/csv/parallel/csv_parallel_httpfs.test"
        "test/sql/copy/csv/parallel/test_parallel_csv.test"
        "test/sql/copy/csv/test_csv_httpfs_prepared.test"
        "test/sql/copy/csv/test_csv_httpfs.test"
        "test/sql/copy/csv/test_csv_remote.test"
        "test/sql/copy/parquet/delta_byte_array_length_mismatch.test"
        "test/sql/copy/parquet/delta_byte_array_multiple_pages.test"
        "test/sql/copy/parquet/parquet_5968.test"
        "test/sql/copy/parquet/snowflake_lineitem.test"
        "test/sql/copy/parquet/test_parquet_force_download.test"
        "test/sql/copy/parquet/test_parquet_remote_foreign_files.test"
        "test/sql/copy/parquet/test_parquet_remote.test"
        "test/sql/json/table/read_json_objects.test"
        "test/sql/json/table/read_json.test"
        "test/sql/settings/test_disabled_file_system_httpfs.test"
        "test/sql/storage/compression/bitpacking/bitpacking_size_calculation.test"

        # these are only hidden if no filters are passed in
        "[!hide]"
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
