{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  poetry-core,
  setuptools,

  # dependencies
  cachetools,
  click,
  fsspec,
  mmh3,
  pydantic,
  pyparsing,
  ray,
  requests,
  rich,
  sortedcontainers,
  strictyaml,
  tenacity,
  zstandard,

  # optional-dependencies
  adlfs,
  # getdaft,
  duckdb,
  pyarrow,
  boto3,
  gcsfs,
  mypy-boto3-glue,
  thrift,
  pandas,
  s3fs,
  python-snappy,
  psycopg2-binary,
  sqlalchemy,

  # tests
  azure-core,
  azure-storage-blob,
  fastavro,
  moto,
  pyspark,
  pytestCheckHook,
  pytest-lazy-fixture,
  pytest-mock,
  pytest-timeout,
  requests-mock,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "iceberg-python";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "iceberg-python";
    tag = "pyiceberg-${version}";
    hash = "sha256-L3YlOtzJv9R4TLeJGzfMQ+0nYtQEsqmgNZpW9B6vVAI=";
  };

  patches = [
    # Build script fails to build the cython extension on python 3.11 (no issues with python 3.12):
    # distutils.errors.DistutilsSetupError: each element of 'ext_modules' option must be an Extension instance or 2-tuple
    # This error vanishes if Cython and setuptools imports are swapped
    # https://stackoverflow.com/a/53356077/11196710
    ./reorder-imports-in-build-script.patch
  ];

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  # Prevents the cython build to fail silently
  env.CIBUILDWHEEL = "1";

  dependencies = [
    cachetools
    click
    fsspec
    mmh3
    pydantic
    pyparsing
    ray
    requests
    rich
    sortedcontainers
    strictyaml
    tenacity
    zstandard
  ];

  optional-dependencies = {
    adlfs = [
      adlfs
    ];
    daft = [
      # getdaft
    ];
    duckdb = [
      duckdb
      pyarrow
    ];
    dynamodb = [
      boto3
    ];
    gcsfs = [
      gcsfs
    ];
    glue = [
      boto3
      mypy-boto3-glue
    ];
    hive = [
      thrift
    ];
    pandas = [
      pandas
      pyarrow
    ];
    pyarrow = [
      pyarrow
    ];
    ray = [
      pandas
      pyarrow
      ray
    ];
    s3fs = [
      s3fs
    ];
    snappy = [
      python-snappy
    ];
    sql-postgres = [
      psycopg2-binary
      sqlalchemy
    ];
    sql-sqlite = [
      sqlalchemy
    ];
    zstandard = [
      zstandard
    ];
  };

  pythonImportsCheck = [
    "pyiceberg"
    # Compiled avro decoder (cython)
    "pyiceberg.avro.decoder_fast"
  ];

  nativeCheckInputs = [
    azure-core
    azure-storage-blob
    boto3
    fastavro
    moto
    mypy-boto3-glue
    pandas
    pyarrow
    pyspark
    pytest-lazy-fixture
    pytest-mock
    pytest-timeout
    pytestCheckHook
    requests-mock
    s3fs
    sqlalchemy
    thrift
  ] ++ moto.optional-dependencies.server;

  disabledTestPaths = [
    # Several errors:
    # - FileNotFoundError: [Errno 2] No such file or directory: '/nix/store/...-python3.12-pyspark-3.5.3/lib/python3.12/site-packages/pyspark/./bin/spark-submit'
    # - requests.exceptions.ConnectionError: HTTPConnectionPool(host='localhost', port=8181): Max retries exceeded with url: /v1/config
    # - thrift.transport.TTransport.TTransportException: Could not connect to any of [('127.0.0.1', 9083)]
    "tests/integration"
  ];

  disabledTests = [
    # botocore.exceptions.EndpointConnectionError: Could not connect to the endpoint URL
    "test_checking_if_a_file_exists"
    "test_closing_a_file"
    "test_fsspec_file_tell"
    "test_fsspec_getting_length_of_file"
    "test_fsspec_pickle_round_trip_s3"
    "test_fsspec_raise_on_opening_file_not_found"
    "test_fsspec_read_specified_bytes_for_file"
    "test_fsspec_write_and_read_file"
    "test_writing_avro_file"

    # Require unpackaged gcsfs
    "test_fsspec_converting_an_outputfile_to_an_inputfile_gcs"
    "test_fsspec_new_input_file_gcs"
    "test_fsspec_new_output_file_gcs"
    "test_fsspec_pickle_roundtrip_gcs"

    # Timeout (network access)
    "test_fsspec_converting_an_outputfile_to_an_inputfile_adls"
    "test_fsspec_new_abfss_output_file_adls"
    "test_fsspec_new_input_file_adls"
    "test_fsspec_pickle_round_trip_aldfs"

    # TypeError: pyarrow.lib.large_list() takes no keyword argument
    # From tests/io/test_pyarrow_stats.py:
    "test_bounds"
    "test_column_metrics_mode"
    "test_column_sizes"
    "test_metrics_mode_counts"
    "test_metrics_mode_full"
    "test_metrics_mode_non_default_trunc"
    "test_metrics_mode_none"
    "test_null_and_nan_counts"
    "test_offsets"
    "test_read_missing_statistics"
    "test_record_count"
    "test_value_counts"
    "test_write_and_read_stats_schema"
    # From tests/io/test_pyarrow.py:
    "test_list_type_to_pyarrow"
    "test_projection_add_column"
    "test_projection_list_of_structs"
    "test_read_list"
    "test_schema_compatible_missing_nullable_field_nested"
    "test_schema_compatible_nested"
    "test_schema_mismatch_missing_required_field_nested"
    "test_schema_to_pyarrow_schema_exclude_field_ids"
    "test_schema_to_pyarrow_schema_include_field_ids"
    # From tests/io/test_pyarrow_visitor.py
    "test_round_schema_conversion_nested"

    # Hangs forever (from tests/io/test_pyarrow.py)
    "test_getting_length_of_file_gcs"
  ];

  meta = {
    description = "Python library for programmatic access to Apache Iceberg";
    homepage = "https://github.com/apache/iceberg-python";
    changelog = "https://github.com/apache/iceberg-python/releases/tag/pyiceberg-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
