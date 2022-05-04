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
}:

buildPythonPackage rec {
  pname = "apache-beam";
  version = "2.37.0";
  disabled = pythonAtLeast "3.10";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "beam";
    rev = "v${version}";
    sha256 = "sha256-FmfTxRLqXUHhhAZIxCRx2+phX0bmU5rIHaftBU4yBJY=";
  };

  # See https://github.com/NixOS/nixpkgs/issues/156957.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "dill>=0.3.1.1,<0.3.2" "dill" \
      --replace "httplib2>=0.8,<0.20.0" "httplib2" \
      --replace "pyarrow>=0.15.1,<7.0.0" "pyarrow"
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
    sqlalchemy
    tenacity
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
    # Test relies on the testcontainers package, which is not currently (as of
    # 2022-04-08) available in nixpkgs.
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
  ];

  meta = with lib; {
    description = "Unified model for defining both batch and streaming data-parallel processing pipelines";
    homepage = "https://beam.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
