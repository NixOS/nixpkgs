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
  cryptography,
  dill,
  envoy-data-plane,
  fastavro,
  fasteners,
  grpcio,
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
  which,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "apache-beam";
  version = "2.71.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "beam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pIuRaBN1lmC3EMuUnBovl/pBmNwsDZ/vh/OM/sD9SrI=";
  };

  sourceRoot = "${finalAttrs.src.name}/sdks/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "==" ">="

    substituteInPlace setup.py \
      --replace-fail "  copy_tests_from_docs()" ""
  '';

  pythonRelaxDeps = [
    "envoy-data-plane"
    "jsonpickle"
    "objsize"
    "pyarrow"
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
    cryptography
    dill
    envoy-data-plane
    fastavro
    fasteners
    grpcio
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
    which
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

    # AttributeError: '_TruncatingFileHandle' object has no attribute 'close'.
    "apache_beam/ml/rag/ingestion/milvus_search_it_test.py"

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
    # AssertionError: Lists differ:
    # ['pickled_main_session', 'submission_environment_dependencies.txt'] != ['pickled_main_session']
    "test_main_session_staged_when_using_cloudpickle"

    # TypeError: NoneType takes no arguments
    "test_run_inference_with_rate_limiter"
    "test_run_inference_with_rate_limiter_exceeded"

    # RuntimeError: This pipeline runs with the pipeline option --update_compatibility_version=2.67.0 or earlier.
    # When running with this option on SDKs 2.68.0 or later, you must ensure dill==0.3.1.1 is installed. Error
    "test_reshuffle_custom_window_preserves_metadata_1"
    "test_reshuffle_default_window_preserves_metadata_1"

    # Dill version 0.3.1.1 is required when using pickle_library=dill.
    # Other versions of dill are untested with Apache Beam.
    "LocalCombineFnLifecycleTest_0_dill"
    "LocalCombineFnLifecycleTest_2_dill"
    "test_runner_overrides_default_pickler"

    # Require internet access
    "test_local_jar_fallback_to_google_maven_mirror"

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
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # TypeError: Could not determine schema for type hint Any.
    # Did you mean to create a schema-aware PCollection? See https://s.apache.org/beam-python-schemas
    "test_dataframes"
    "test_dataframes_same_cell_twice"

    # AssertionError: 'OptionalUnionType(unnamed: int | str | None)' not found in ('OptionalUnionType(unnamed: typing.Union[int, str, NoneType])', 'OptionalUnionType(unnamed: typing.Union[str, int, NoneType])')
    "test_pformat_namedtuple_with_unnamed_fields"

    # AssertionError: Lists differ:
    # ['ref[26 chars]_Coder_FastPrimitivesCoder_3', 'ref_Coder_GlobalWindowCoder_2']
    # != ['ref[26 chars]_Coder_GlobalWindowCoder_2', 'ref_Coder_VersionedCoder_v269_3']
    "test_coder_version_tag_included_in_runner_api_key"

    # AttributeError: 'int' object has no attribute 'upper' [while running 'Map(<lambda at core_test.py:555>)']
    "test_typecheck_with_default"

    # AssertionError: Any != <class 'int'> (or similar type mismatches)
    "test_child_without_output_hints_infers_partial_types_from_dofn"
    "test_combine_properly_pipeline_type_checks_using_decorator"
    "test_combine_properly_pipeline_type_checks_without_decorator"
    "test_filter_typehint"
    "test_mean_globally_pipeline_checking_satisfied"
    "test_mean_globally_runtime_checking_satisfied"
    "test_pardo_type_inference"
    "test_pipeline_inference"
    "test_ptransform_override_type_hints"
    "test_type_inference"

    # AssertionError: TypeCheckError not raised
    "test_inferred_bad_kv_type"

    # RuntimeError: NotImplementedError [while running 'WithKeys(<lambda at...y:232>)/Map(<lambda at util.py:1193>)']
    "test_co_group_by_key_on_unpickled"

    # TypeError: object of type 'member_descriptor' has no len()
    "test_convert_bare_types_fail"
    # TypeError: Parameter to List hint must be a non-sequence, a type, or a TypeConstraint.
    # ForwardRef('int') is an instance of ForwardRef
    "test_forward_reference"
    # TypeError: Unable to deterministically encode ...
    "test_deterministic_key"
  ];

  meta = {
    description = "Unified model for defining both batch and streaming data-parallel processing pipelines";
    homepage = "https://beam.apache.org/";
    changelog = "https://github.com/apache/beam/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
})
