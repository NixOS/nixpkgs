{ buildPythonPackage
, cloudpickle
, crcmod
, cython
, dill
, fastavro
, fetchFromGitHub
, fetchpatch
, freezegun
, grpcio
, grpcio-tools
, hdfs
, httplib2
, lib
, mock
, mypy-protobuf
, numpy
, oauth2client
, orjson
, pandas
, parameterized
, proto-plus
, protobuf
, psycopg2
, pyarrow
, pydot
, pyhamcrest
, pymongo
, pytestCheckHook
, python
, python-dateutil
, pythonAtLeast
, pythonRelaxDepsHook
, pytz
, pyyaml
, requests
, requests-mock
, scikit-learn
, setuptools
, sqlalchemy
, tenacity
, testcontainers
, typing-extensions
}:

buildPythonPackage rec {
  pname = "apache-beam";
  version = "2.43.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "beam";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-lqGXCC66eyBnHcK06k9knggX5C+2d0m6xBAI5sh0RHo=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/apache/beam/pull/24143
      name = "fix-for-dill-0.3.6.patch";
      url = "https://github.com/apache/beam/commit/7e014435b816015d21cc07f3f6c80809f3d8023d.patch";
      hash = "sha256-iUmnzrItTFM98w3mpadzrmtI3t0fucpSujAg/6qxCGk=";
      stripLen = 2;
    })
    (fetchpatch {
      # https://github.com/apache/beam/pull/24573
      name = "relax-httplib2-version.patch";
      url = "https://github.com/apache/beam/commit/4045503575ae5ccef3de8d7b868c54e37fef658b.patch";
      hash = "sha256-YqT+sHaa1R9vLQnEQN2K0lYoCdnGoPY9qduGBpXPaek=";
      stripLen = 2;
    })
  ];

  pythonRelaxDeps = [
    # See https://github.com/NixOS/nixpkgs/issues/156957
    "dill"
    "numpy"
    "pyarrow"
    "pymongo"

    # See https://github.com/NixOS/nixpkgs/issues/193613
    "protobuf"
  ];

  sourceRoot = "source/sdks/python";

  nativeBuildInputs = [
    cython
    grpcio-tools
    mypy-protobuf
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    cloudpickle
    crcmod
    cython
    dill
    fastavro
    grpcio
    hdfs
    httplib2
    numpy
    oauth2client
    orjson
    proto-plus
    protobuf
    pyarrow
    pydot
    pymongo
    python-dateutil
    pytz
    requests
    setuptools
    typing-extensions
  ];

  enableParallelBuilding = true;

  pythonImportsCheck = [
    "apache_beam"
  ];

  checkInputs = [
    freezegun
    mock
    pandas
    parameterized
    psycopg2
    pyhamcrest
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
  preCheck = "cd $out/lib/${python.libPrefix}/site-packages";

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
  ];

  meta = with lib; {
    description = "Unified model for defining both batch and streaming data-parallel processing pipelines";
    homepage = "https://beam.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
