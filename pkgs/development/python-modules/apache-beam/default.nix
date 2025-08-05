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
  version = "2.65.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "beam";
    tag = "v${version}";
    hash = "sha256-vDW0PVNep+egIZBe4t8IPwLgsQDmoO4rrA4wUoAHzfg=";
  };

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

  sourceRoot = "${src.name}/sdks/python";

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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "distlib==0.3.7" "distlib" \
      --replace-fail "yapf==0.29.0" "yapf" \
      --replace-fail "grpcio-tools==1.62.1" "grpcio-tools" \
      --replace-fail "mypy-protobuf==3.5.0" "mypy-protobuf" \
      --replace-fail "numpy>=1.14.3,<2.3.0" "numpy"

    substituteInPlace setup.py \
      --replace-fail "  copy_tests_from_docs()" ""
  '';

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

    # FIXME All those fails due to a single- AttributeError: 'MaybeReshuffle' object has no attribute 'side_inputs'
    # Upstream issue https://github.com/apache/beam/issues/33854
    "apache_beam/coders/row_coder_test.py"
    "apache_beam/examples/avro_nyc_trips_test.py"
    "apache_beam/examples/complete/autocomplete_test.py"
    "apache_beam/examples/complete/estimate_pi_test.py"
    "apache_beam/examples/complete/game/game_stats_test.py"
    "apache_beam/examples/complete/game/hourly_team_score_test.py"
    "apache_beam/examples/complete/game/leader_board_test.py"
    "apache_beam/examples/complete/game/user_score_test.py"
    "apache_beam/examples/complete/tfidf_test.py"
    "apache_beam/examples/complete/top_wikipedia_sessions_test.py"
    "apache_beam/examples/cookbook/bigquery_side_input_test.py"
    "apache_beam/examples/cookbook/bigquery_tornadoes_test.py"
    "apache_beam/examples/cookbook/coders_test.py"
    "apache_beam/examples/cookbook/combiners_test.py"
    "apache_beam/examples/cookbook/custom_ptransform_test.py"
    "apache_beam/examples/cookbook/filters_test.py"
    "apache_beam/examples/matrix_power_test.py"
    "apache_beam/examples/snippets/snippets_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/approximatequantiles_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/approximateunique_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/batchelements_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/cogroupbykey_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/combineglobally_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/combineperkey_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/combinevalues_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/count_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/distinct_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/groupbykey_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/groupintobatches_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/latest_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/max_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/mean_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/min_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/sample_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/sum_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/tolist_test.py"
    "apache_beam/examples/snippets/transforms/aggregation/top_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/filter_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/flatmap_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/keys_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/kvswap_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/map_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/pardo_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/partition_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/regex_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/tostring_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/values_test.py"
    "apache_beam/examples/snippets/transforms/elementwise/withtimestamps_test.py"
    "apache_beam/examples/snippets/transforms/other/create_test.py"
    "apache_beam/examples/snippets/transforms/other/flatten_test.py"
    "apache_beam/examples/snippets/transforms/other/window_test.py"
    "apache_beam/examples/snippets/util_test.py"
    "apache_beam/io/avroio_test.py"
    "apache_beam/io/concat_source_test.py"
    "apache_beam/io/filebasedsink_test.py"
    "apache_beam/io/filebasedsource_test.py"
    "apache_beam/io/fileio_test.py"
    "apache_beam/io/mongodbio_test.py"
    "apache_beam/io/parquetio_test.py"
    "apache_beam/io/sources_test.py"
    "apache_beam/io/textio_test.py"
    "apache_beam/io/tfrecordio_test.py"
    "apache_beam/metrics/metric_test.py"
    "apache_beam/ml/inference/base_test.py"
    "apache_beam/ml/inference/sklearn_inference_test.py"
    "apache_beam/ml/inference/utils_test.py"
    "apache_beam/ml/rag/chunking/base_test.py"
    "apache_beam/ml/rag/ingestion/base_test.py"
    "apache_beam/pipeline_test.py"
    "apache_beam/runners/direct/direct_runner_test.py"
    "apache_beam/runners/direct/sdf_direct_runner_test.py"
    "apache_beam/runners/interactive/interactive_beam_test.py"
    "apache_beam/runners/interactive/interactive_runner_test.py"
    "apache_beam/runners/interactive/non_interactive_runner_test.py"
    "apache_beam/runners/interactive/recording_manager_test.py"
    "apache_beam/runners/portability/fn_api_runner/translations_test.py"
    "apache_beam/runners/portability/fn_api_runner/trigger_manager_test.py"
    "apache_beam/runners/portability/stager_test.py"
    "apache_beam/testing/synthetic_pipeline_test.py"
    "apache_beam/testing/test_stream_test.py"
    "apache_beam/testing/util_test.py"
    "apache_beam/transforms/combiners_test.py"
    "apache_beam/transforms/core_test.py"
    "apache_beam/transforms/create_test.py"
    "apache_beam/transforms/deduplicate_test.py"
    "apache_beam/transforms/periodicsequence_test.py"
    "apache_beam/transforms/ptransform_test.py"
    "apache_beam/transforms/sideinputs_test.py"
    "apache_beam/transforms/stats_test.py"
    "apache_beam/transforms/transforms_keyword_only_args_test.py"
    "apache_beam/transforms/trigger_test.py"
    "apache_beam/transforms/userstate_test.py"
    "apache_beam/transforms/util_test.py"
    "apache_beam/transforms/write_ptransform_test.py"

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
    changelog = "https://github.com/apache/beam/blob/release-${version}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
