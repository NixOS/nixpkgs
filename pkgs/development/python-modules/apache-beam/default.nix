{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  distlib,
  grpcio-tools,
  jinja2,
  jsonpickle,
  jsonschema,
  mypy-protobuf,
  redis,
  setuptools,
  yapf,

  # dependencies
  beartype,
  crcmod,
  dill,
  fastavro,
  fasteners,
  grpcio,
  hdfs,
  httplib2,
  numpy,
  objsize,
  orjson,
  proto-plus,
  protobuf,
  pyarrow,
  pydot,
  pymongo,
  python-dateutil,
  pytz,
  regex,
  requests,
  typing-extensions,
  zstandard,

  # tests
  python,
  docstring-parser,
  freezegun,
  hypothesis,
  mock,
  pandas,
  parameterized,
  psycopg2,
  pyhamcrest,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  requests-mock,
  scikit-learn,
  sqlalchemy,
  tenacity,
  testcontainers,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "apache-beam";
  version = "2.68.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "beam";
    tag = "v${version}";
    hash = "sha256-ENtvgu9qT1OPsDqFJQzKgIATE7F+S5I+AfoBT2iEL8M=";
  };

  sourceRoot = "${src.name}/sdks/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "==" ">=" \
      --replace-fail ",<2.3.0" ""

    substituteInPlace setup.py \
      --replace-fail "  copy_tests_from_docs()" ""
  '';

  pythonRelaxDeps = [
    "grpcio"
    "jsonpickle"

    # As of apache-beam v2.55.1, the requirement is cloudpickle~=2.2.1, but
    # the current (2024-04-20) nixpkgs's pydot version is 3.0.0.
    "cloudpickle"

    # See https://github.com/NixOS/nixpkgs/issues/156957
    "dill"

    "numpy"

    "protobuf"

    # As of apache-beam v2.45.0, the requirement is pyarrow<10.0.0,>=0.15.1, but
    # the current (2023-02-22) nixpkgs's pyarrow version is 11.0.0.
    "pyarrow"

    "pydot"
    "redis"
  ];

  build-system = [
    cython
    distlib
    grpcio-tools
    jinja2
    jsonpickle
    jsonschema
    mypy-protobuf
    redis
    setuptools
    yapf
  ];

  dependencies = [
    beartype
    crcmod
    dill
    fastavro
    fasteners
    grpcio
    hdfs
    httplib2
    numpy
    objsize
    orjson
    proto-plus
    protobuf
    pyarrow
    pydot
    pymongo
    python-dateutil
    pytz
    regex
    requests
    typing-extensions
    zstandard
  ];

  enableParallelBuilding = true;

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "apache_beam" ];

  nativeCheckInputs = [
    docstring-parser
    freezegun
    hypothesis
    mock
    pandas
    parameterized
    psycopg2
    pyhamcrest
    pytest-xdist
    pytestCheckHook
    pyyaml
    requests-mock
    scikit-learn
    sqlalchemy
    tenacity
    testcontainers
  ];

  # Make sure we're running the tests for the actually installed
  # package, so that cython's .so files are available.
  preCheck = ''
    cd $out/${python.sitePackages}
  '';

  disabledTestPaths = [
    #  FileNotFoundError: [Errno 2] No such file or directory:
    # '/nix/store/...-python3.13-apache-beam-2.67.0/lib/python3.13/site-packages/apache_beam/yaml/docs/yaml.md'
    "apache_beam/yaml/examples/testing/examples_test.py"

    # from google.cloud.sql.connector import Connector
    # E   ModuleNotFoundError: No module named 'google.cloud'
    "apache_beam/ml/rag/ingestion/cloudsql_it_test.py"

    # Fails with
    #     _______ ERROR collecting apache_beam/io/external/xlang_jdbcio_it_test.py _______
    #     apache_beam/io/external/xlang_jdbcio_it_test.py:80: in <module>
    #         class CrossLanguageJdbcIOTest(unittest.TestCase):
    #     apache_beam/io/external/xlang_jdbcio_it_test.py:99: in CrossLanguageJdbcIOTest
    #         container_init: Callable[[], Union[PostgresContainer, MySqlContainer]],
    #     E   NameError: name 'MySqlContainer' is not defined
    #
    "apache_beam/io/external/xlang_jdbcio_it_test.py"

    # These tests depend on the availability of specific servers backends.
    "apache_beam/runners/portability/flink_runner_test.py"
    "apache_beam/runners/portability/samza_runner_test.py"
    "apache_beam/runners/portability/spark_runner_test.py"

    # Fails starting from dill 0.3.6 because it tries to pickle pytest globals:
    # https://github.com/uqfoundation/dill/issues/482#issuecomment-1139017499.
    "apache_beam/transforms/window_test.py"

    # See https://github.com/apache/beam/issues/25390.
    "apache_beam/coders/slow_coders_test.py"
    "apache_beam/dataframe/pandas_doctests_test.py"
    "apache_beam/typehints/typed_pipeline_test.py"
    "apache_beam/coders/fast_coders_test.py"
    "apache_beam/dataframe/schemas_test.py"

    # Fails with TypeError: cannot pickle 'EncodedFile' instances
    # Upstream issue https://github.com/apache/beam/issues/33889
    "apache_beam/options/pipeline_options_validator_test.py"
    "apache_beam/yaml/main_test.py"
    "apache_beam/yaml/programming_guide_test.py"
    "apache_beam/yaml/readme_test.py"
    "apache_beam/yaml/yaml_combine_test.py"
    "apache_beam/yaml/yaml_enrichment_test.py"
    "apache_beam/yaml/yaml_io_test.py"
    "apache_beam/yaml/yaml_join_test.py"
    "apache_beam/yaml/yaml_mapping_test.py"
    "apache_beam/yaml/yaml_ml_test.py"
    "apache_beam/yaml/yaml_provider_unit_test.py"

    # FIXME AttributeError: 'Namespace' object has no attribute 'test_pipeline_options'
    # Upstream issue https://github.com/apache/beam/issues/33853
    "apache_beam/runners/portability/prism_runner_test.py"

    # FIXME ValueError: Unable to run pipeline with requirement: unsupported_requirement
    # Upstream issuehttps://github.com/apache/beam/issues/33853
    "apache_beam/yaml/yaml_transform_scope_test.py"
    "apache_beam/yaml/yaml_transform_test.py"
    "apache_beam/yaml/yaml_transform_unit_test.py"
    "apache_beam/yaml/yaml_udf_test.py"
    "apache_beam/dataframe/frames_test.py"

    # FIXME Those tests do not terminate due to a grpc error (threading issue)
    # grpc_status:14, grpc_message:"Cancelling all calls"}"
    # Upstream issue https://github.com/apache/beam/issues/33851
    "apache_beam/runners/portability/portable_runner_test.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # > instruction = ofs_table[pc]
    # E KeyError: 18
    "apache_beam/typehints/trivial_inference_test.py"
  ];

  disabledTests = [
    # RuntimeError: This pipeline runs with the pipeline option --update_compatibility_version=2.67.0 or earlier.
    # When running with this option on SDKs 2.68.0 or later, you must ensure dill==0.3.1.1 is installed. Error
    "test_reshuffle_custom_window_preserves_metadata_1"
    "test_reshuffle_default_window_preserves_metadata_1"

    # AttributeError: 'MaybeReshuffle' object has no attribute 'side_inputs'
    # https://github.com/apache/beam/issues/33854
    "test_runner_overrides_default_pickler"

    # AssertionError: Lists differ
    "test_default_resources"
    "test_files_to_stage"
    "test_main_session_not_staged_when_using_cloudpickle"
    "test_no_main_session"
    "test_populate_requirements_cache_with_local_files"
    "test_requirements_cache_not_populated_when_cache_disabled"
    "test_sdk_location_default"
    "test_sdk_location_http"
    "test_sdk_location_local_directory"
    "test_sdk_location_local_source_file"
    "test_sdk_location_local_wheel_file"
    "test_sdk_location_remote_source_file"
    "test_sdk_location_remote_wheel_file"
    "test_with_extra_packages"
    "test_with_jar_packages"
    "test_with_main_session"
    "test_with_pypi_requirements"
    "test_with_requirements_file"
    "test_with_requirements_file_and_cache"

    # ValueError: SplitAtFraction test completed vacuously: no non-trivial split fractions found
    "test_dynamic_work_rebalancing"

    # fixture 'self' not found
    "test_with_batched_input_exceeds_size_limit"
    "test_with_batched_input_splits_large_batch"

    # IndexError: list index out of range
    "test_only_sample_exceptions"

    # AssertionError: False is not true
    "test_samples_all_with_both_experiments"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    #  PermissionError: [Errno 13] Permission denied: '/tmp/...'
    "test_cache_manager_uses_local_ib_cache_root"
    "test_describe_all_recordings"
    "test_find_out_correct_user_pipeline"
    "test_get_cache_manager_creates_cache_manager_if_absent"
    "test_streaming_cache_uses_local_ib_cache_root"
    "test_track_user_pipeline_cleanup_non_inspectable_pipeline"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # TypeError: Could not determine schema for type hint Any.
    "test_batching_beam_row_input"
    "test_auto_convert"
    "test_unbatching_series"
    "test_batching_beam_row_to_dataframe"

    # AssertionError: Any != <class 'int'>
    "test_pycallable_map"
    "testAlwaysReturnsEarly"

    # TypeError: Expected Iterator in return type annotatio
    "test_get_output_batch_type"
  ];

  meta = {
    description = "Unified model for defining both batch and streaming data-parallel processing pipelines";
    homepage = "https://beam.apache.org/";
    changelog = "https://github.com/apache/beam/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
