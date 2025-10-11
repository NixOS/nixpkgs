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
  google-auth,
  mmh3,
  pydantic,
  pyparsing,
  pyroaring,
  ray,
  requests,
  rich,
  sortedcontainers,
  strictyaml,
  tenacity,
  zstandard,

  # optional-dependencies
  adlfs,
  google-cloud-bigquery,
  # bodo,
  # daft,
  duckdb,
  pyarrow,
  pyiceberg-core,
  boto3,
  huggingface-hub,
  gcsfs,
  thrift,
  kerberos,
  # thrift-sasl,
  pandas,
  # pyiceberg-core,
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
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "iceberg-python";
    tag = "pyiceberg-${version}";
    hash = "sha256-uR8nmKVjYjiArcNaf/Af2kGh14p59VV9g2mKPKmiJnc=";
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
    "cachetools"
    "rich"
  ];

  dependencies = [
    cachetools
    click
    fsspec
    google-auth
    mmh3
    pydantic
    pyparsing
    pyroaring
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
    bigquery = [
      google-cloud-bigquery
    ];
    bodo = [
      # bodo
    ];
    daft = [
      # daft
    ];
    duckdb = [
      duckdb
      pyarrow
    ];
    dynamodb = [
      boto3
    ];
    hf = [
      huggingface-hub
    ];
    gcsfs = [
      gcsfs
    ];
    glue = [
      boto3
    ];
    hive = [
      thrift
    ];
    hive-kerberos = [
      kerberos
      thrift
      # thrift-sasl
    ];
    pandas = [
      pandas
      pyarrow
    ];
    pyarrow = [
      pyarrow
      pyiceberg-core
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
    pyspark
    pytest-lazy-fixture
    pytest-mock
    pytest-timeout
    pytestCheckHook
    requests-mock
  ]
  ++ optional-dependencies.bigquery
  ++ optional-dependencies.hive
  ++ optional-dependencies.pandas
  ++ optional-dependencies.pyarrow
  ++ optional-dependencies.s3fs
  ++ optional-dependencies.sql-sqlite
  ++ moto.optional-dependencies.server;

  pytestFlags = [
    # ResourceWarning: unclosed database in <sqlite3.Connection object at 0x7ffe7c6f4220>
    "-Wignore::ResourceWarning"
  ];

  disabledTestPaths = [
    # Several errors:
    # - FileNotFoundError: [Errno 2] No such file or directory: '/nix/store/...-python3.12-pyspark-3.5.3/lib/python3.12/site-packages/pyspark/./bin/spark-submit'
    # - requests.exceptions.ConnectionError: HTTPConnectionPool(host='localhost', port=8181): Max retries exceeded with url: /v1/config
    # - thrift.transport.TTransport.TTransportException: Could not connect to any of [('127.0.0.1', 9083)]
    "tests/integration"
  ];

  disabledTests = [
    # KeyError: 'authorization'
    "test_token_200"
    "test_token_200_without_optional_fields"
    "test_token_with_default_scope"
    "test_token_with_optional_oauth_params"
    "test_token_with_custom_scope"

    # AttributeError: 'SessionContext' object has no attribute 'register_table_provider'
    "test_datafusion_register_pyiceberg_tabl"

    # ModuleNotFoundError: No module named 'puresasl'
    "test_create_hive_client_with_kerberos"
    "test_create_hive_client_with_kerberos_using_context_manager"

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
    "test_config_200"
    "test_fsspec_converting_an_outputfile_to_an_inputfile_adls"
    "test_fsspec_new_abfss_output_file_adls"
    "test_fsspec_new_input_file_adls"
    "test_fsspec_pickle_round_trip_aldfs"
    "test_partitioned_write"
    "test_token_200_w_oauth2_server_uri"

    # azure.core.exceptions.ServiceRequestError (network access)
    "test_converting_an_outputfile_to_an_inputfile_adls"
    "test_file_tell_adls"
    "test_getting_length_of_file_adls"
    "test_new_input_file_adls"
    "test_new_output_file_adls"
    "test_raise_on_opening_file_not_found_adls"
    "test_read_specified_bytes_for_file_adls"
    "test_write_and_read_file_adls"

    # Hangs forever (from tests/io/test_pyarrow.py)
    "test_getting_length_of_file_gcs"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # ImportError: The pyarrow installation is not built with support for 'GcsFileSystem'
    "test_converting_an_outputfile_to_an_inputfile_gcs"
    "test_create_table_with_database_location"
    "test_drop_table_with_database_location"
    "test_new_input_file_gcs"
    "test_new_output_file_gc"

    # PermissionError: [Errno 13] Failed to open local file
    # '/tmp/iceberg/warehouse/default.db/test_projection_partitions/metadata/00000-6c1c61a1-495f-45d3-903d-a2643431be91.metadata.json'
    "test_identity_transform_column_projection"
    "test_identity_transform_columns_projection"
    "test_in_memory_catalog_context_manager"
    "test_inspect_partition_for_nested_field"
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
