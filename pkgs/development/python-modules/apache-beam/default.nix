{ buildPythonPackage
, cloudpickle
, crcmod
, cython
, dill
, fastavro
, fetchFromGitHub
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
, pythonAtLeast
, python-dateutil
, pytz
, pyyaml
, requests
, requests-mock
, setuptools
, sqlalchemy
, tenacity
, typing-extensions
, testcontainers
, scikit-learn }:

buildPythonPackage rec {
  pname = "apache-beam";
  version = "2.40.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "beam";
    rev = "v${version}";
    sha256 = "sha256-0S7Dj6PMSbZkEAY6ZLUpKVfe/tFxsq60TTAFj0Qhtv0=";
  };

  # See https://github.com/NixOS/nixpkgs/issues/156957.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "dill>=0.3.1.1,<0.3.2" "dill" \
      --replace "pyarrow>=0.15.1,<8.0.0" "pyarrow" \
      --replace "numpy>=1.14.3,<1.23.0" "numpy" \
      --replace "pymongo>=3.8.0,<4.0.0" "pymongo"
  '';

  sourceRoot = "source/sdks/python";

  nativeBuildInputs = [
    cython
    grpcio-tools
    mypy-protobuf
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
