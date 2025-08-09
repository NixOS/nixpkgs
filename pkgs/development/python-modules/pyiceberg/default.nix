{
  lib,
  stdenv,
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
  datafusion,
  fastavro,
  moto,
  pyspark,
  pytestCheckHook,
  pytest-lazy-fixture,
  pytest-mock,
  pytest-timeout,
  requests-mock,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "iceberg-python";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "iceberg-python";
    tag = "pyiceberg-${version}";
    hash = "sha256-OUj8z/UOIcK0S4tf6Id52YHweNDfYnX6P4nChXrOxqY=";
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

  pythonRelaxDeps = [
    "rich"
  ];

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
    datafusion
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
  ]
  ++ moto.optional-dependencies.server;

  pytestFlags = [
    # ResourceWarning: unclosed database in <sqlite3.Connection object at 0x7ffe7c6f4220>
    "-Wignore::pytest.PytestUnraisableExceptionWarning"
  ];

  disabledTestPaths = [
    # Several errors:
    # - FileNotFoundError: [Errno 2] No such file or directory: '/nix/store/...-python3.12-pyspark-3.5.3/lib/python3.12/site-packages/pyspark/./bin/spark-submit'
    # - requests.exceptions.ConnectionError: HTTPConnectionPool(host='localhost', port=8181): Max retries exceeded with url: /v1/config
    # - thrift.transport.TTransport.TTransportException: Could not connect to any of [('127.0.0.1', 9083)]
    "tests/integration"
  ];

  disabledTests = [
    # ModuleNotFoundError: No module named 'puresasl'
    "test_create_hive_client_with_kerberos"
    "test_create_hive_client_with_kerberos_using_context_manager"

    # Require unpackaged pyiceberg_core
    "test_bucket_pyarrow_transforms"
    "test_transform_consistency_with_pyarrow_transform"
    "test_truncate_pyarrow_transforms"

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
    "test_partitioned_write"
    "test_token_200_w_oauth2_server_uri"

    # Hangs forever (from tests/io/test_pyarrow.py)
    "test_getting_length_of_file_gcs"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # ImportError: The pyarrow installation is not built with support for 'GcsFileSystem'
    "test_converting_an_outputfile_to_an_inputfile_gcs"
    "test_new_input_file_gcs"
    "test_new_output_file_gc"

    # PermissionError: [Errno 13] Failed to open local file
    # '/tmp/iceberg/warehouse/default.db/test_projection_partitions/metadata/00000-6c1c61a1-495f-45d3-903d-a2643431be91.metadata.json'
    "test_identity_transform_column_projection"
    "test_identity_transform_columns_projection"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # AssertionError:
    # assert "Incompatible with StructProtocol: <class 'str'>" in "Unable to initialize struct: <class 'str'>"
    "test_read_not_struct_type"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python library for programmatic access to Apache Iceberg";
    homepage = "https://github.com/apache/iceberg-python";
    changelog = "https://github.com/apache/iceberg-python/releases/tag/pyiceberg-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
