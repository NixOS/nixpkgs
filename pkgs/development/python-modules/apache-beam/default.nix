{ buildPythonPackage
, cloudpickle
, crcmod
, cython
, dill
, fastavro
, fasteners
, fetchFromGitHub
, fetchpatch
, freezegun
, grpcio
, grpcio-tools
, hdfs
, httplib2
, hypothesis
, lib
, mock
, mypy-protobuf
, numpy
, objsize
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
, pytest-xdist
, pytestCheckHook
, python
, python-dateutil
, pythonRelaxDepsHook
, pytz
, pyyaml
, regex
, requests
, requests-mock
, scikit-learn
, sqlalchemy
, tenacity
, testcontainers
, typing-extensions
, zstandard
}:

buildPythonPackage rec {
  pname = "apache-beam";
  version = "2.50.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "beam";
    rev = "refs/tags/v${version}";
    hash = "sha256-qaxYWPVdMlegvH/W66UBoQbcQ5Ac/3DNoQs8xo+KfLc=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/apache/beam/pull/24143
      name = "fix-for-dill-0.3.6.patch";
      url = "https://github.com/apache/beam/commit/7e014435b816015d21cc07f3f6c80809f3d8023d.patch";
      hash = "sha256-iUmnzrItTFM98w3mpadzrmtI3t0fucpSujAg/6qxCGk=";
      stripLen = 2;
    })
  ];

  pythonRelaxDeps = [
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
    cython
    grpcio-tools
    mypy-protobuf
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    cloudpickle
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

  pythonImportsCheck = [
    "apache_beam"
  ];

  checkInputs = [
    freezegun
    hypothesis
    mock
    pandas
    parameterized
    psycopg2
    pyhamcrest
    pytestCheckHook
    pytest-xdist
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

    # See https://github.com/apache/beam/issues/25390.
    "apache_beam/coders/slow_coders_test.py"
    "apache_beam/dataframe/pandas_doctests_test.py"
    "apache_beam/typehints/typed_pipeline_test.py"
    "apache_beam/coders/fast_coders_test.py"
    "apache_beam/dataframe/schemas_test.py"
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
    "test_batch_encode_decode"
  ];

  meta = with lib; {
    description = "Unified model for defining both batch and streaming data-parallel processing pipelines";
    homepage = "https://beam.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
    # https://github.com/apache/beam/issues/27221
    broken = lib.versionAtLeast pandas.version "2";
  };
}
