{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pythonRelaxDepsHook,

  # build-system
  cython,
  distlib,
  grpcio-tools,
  jinja2,
  mypy-protobuf,
  pyyaml,
  setuptools,
  yapf,

  # dependencies
  cloudpickle,
  crcmod,
  dill,
  fastavro,
  fasteners,
  grpcio,
  hdfs,
  httplib2,
  jsonpickle,
  jsonschema,
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
  redis,
  regex,
  requests,
  typing-extensions,
  zstandard,

  # checks
  python,
  docstring-parser,
  freezegun,
  hypothesis,
  mock,
  pandas,
  parameterized,
  psycopg2,
  pyhamcrest,
  pytestCheckHook,
  pytest-xdist,
  requests-mock,
  scikit-learn,
  sqlalchemy,
  tenacity,
  testcontainers,
}:

buildPythonPackage rec {
  pname = "apache-beam";
  version = "2.62.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "beam";
    tag = "v${version}";
    hash = "sha256-vLvnRZAQg9nhUOI0SIUn+9Y8O7edK3445PkdhPbhO3Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "distlib==0.3.7" "distlib" \
      --replace-fail "yapf==0.29.0" "yapf" \
      --replace-fail "grpcio-tools==1.62.1" "grpcio-tools" \
      --replace-fail "mypy-protobuf==3.5.0" "mypy-protobuf" \
      --replace-fail "numpy>=1.14.3,<2.3.0" "numpy"
  '';

  pythonRelaxDeps = [
    "grpcio"
    "mypy-protobuf"

    # As of apache-beam v2.55.1, the requirement is cloudpickle~=2.2.1, but
    # the current (2024-04-20) nixpkgs's pydot version is 3.0.0.
    "cloudpickle"

    # As of apache-beam v2.55.1, the requirement is pydot>=1.2.0,<2, but
    # the current (2024-04-20) nixpkgs's pydot version is 2.0.0.
    "pydot"

    # See https://github.com/NixOS/nixpkgs/issues/156957
    "dill"
    "numpy"
    "pymongo"

    # See https://github.com/NixOS/nixpkgs/issues/193613
    "protobuf"

    # As of apache-beam v2.45.0, the requirement is httplib2>=0.8,<0.21.0, but
    # the current (2023-02-08) nixpkgs's httplib2 version is 0.21.0. This can be
    # removed once beam is upgraded since the current requirement on master is
    # for httplib2>=0.8,<0.22.0.
    "httplib2"

    # As of apache-beam v2.45.0, the requirement is pyarrow<10.0.0,>=0.15.1, but
    # the current (2023-02-22) nixpkgs's pyarrow version is 11.0.0.
    "pyarrow"
  ];

  sourceRoot = "${src.name}/sdks/python";

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    cython
    distlib
    grpcio-tools
    jinja2
    mypy-protobuf
    pyyaml
    setuptools
    yapf
  ];

  dependencies = [
    cloudpickle
    crcmod
    dill
    fastavro
    fasteners
    grpcio
    hdfs
    httplib2
    jsonpickle
    jsonschema
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
    redis
    regex
    requests
    typing-extensions
    zstandard
  ];

  enableParallelBuilding = true;

  # If this directory doesn't exist, the build script fails
  # https://github.com/apache/beam/blob/v2.62.0/sdks/python/setup.py#L213-L215
  preBuild = ''
    mkdir apache_beam/yaml/docs
  '';

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
    pytestCheckHook
    # pytest-xdist
    pyyaml
    requests-mock
    scikit-learn
    sqlalchemy
    tenacity
    testcontainers
  ];

  # Make sure we're running the tests for the actually installed
  # package, so that cython's .so files are available.
  preCheck = "cd $out/${python.sitePackages}";

  disabledTestPaths = [
    # "apache_beam/yaml/programming_guide_test.py"
    # "apache_beam/yaml/readme_test.py"

    # Fails with
    #     _______ ERROR collecting apache_beam/io/external/xlang_jdbcio_it_test.py _______
    #     apache_beam/io/external/xlang_jdbcio_it_test.py:80: in <module>
    #         class CrossLanguageJdbcIOTest(unittest.TestCase):
    #     apache_beam/io/external/xlang_jdbcio_it_test.py:99: in CrossLanguageJdbcIOTest
    #         container_init: Callable[[], Union[PostgresContainer, MySqlContainer]],
    #     E   NameError: name 'MySqlContainer' is not defined
    #
    # "apache_beam/io/external/xlang_jdbcio_it_test.py"

    # These tests depend on the availability of specific servers backends.
    # "apache_beam/runners/portability/flink_runner_test.py"
    # "apache_beam/runners/portability/samza_runner_test.py"
    # "apache_beam/runners/portability/spark_runner_test.py"

    # Fails starting from dill 0.3.6 because it tries to pickle pytest globals:
    # https://github.com/uqfoundation/dill/issues/482#issuecomment-1139017499.
    # "apache_beam/transforms/window_test.py"

    # See https://github.com/apache/beam/issues/25390.
    # "apache_beam/coders/slow_coders_test.py"
    # "apache_beam/dataframe/pandas_doctests_test.py"
    # "apache_beam/typehints/typed_pipeline_test.py"
    # "apache_beam/coders/fast_coders_test.py"
    # "apache_beam/dataframe/schemas_test.py"
  ];

  disabledTests = [
    # The reasons of failures for these tests are unclear.
    # They reproduce in Docker with Ubuntu 22.04
    # (= they're not `nixpkgs`-specific) but given the upstream uses
    # quite elaborate testing infra with containers and multiple
    # different runners - I don't expect them to help debugging these
    # when running via our (= custom from their PoV) testing infra.
    "test_with_main_session"
    # AssertionErrors
    "test_unified_repr"
    "testDictComprehension"
    "testDictComprehensionSimple"
    "testGenerator"
    "testGeneratorComprehension"
    "testListComprehension"
    "testNoneReturn"
    "testSet"
    "testTupleListComprehension"
    "test_newtype"
    "test_pardo_type_inference"
    "test_get_output_batch_type"
    "test_pformat_namedtuple_with_unnamed_fields"
    "test_row_coder_fail_early_bad_schema"
    # See https://github.com/apache/beam/issues/26004.
    # "test_batch_encode_decode" TODO remove completely
  ];

  pytestFlagsArray = [
    "-vvvv"
    "--maxfail=10"
  ];

  meta = {
    description = "Unified model for defining both batch and streaming data-parallel processing pipelines";
    homepage = "https://beam.apache.org/";
    changelog = "https://github.com/apache/beam/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
