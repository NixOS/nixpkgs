{ lib
, buildPythonPackage
, fetchFromGitHub
, aenum
, aiohttp
, importlib-metadata
, isodate
, nest-asyncio
, six
, pytestCheckHook
, mock
, pyhamcrest
, radish-bdd
}:

buildPythonPackage rec {
  pname = "gremlinpython";
  version = "3.6.0";

  # pypi tarball doesn't include tests
  src = fetchFromGitHub {
    owner = "apache";
    repo = "tinkerpop";
    rev = version;
    sha256 = "0gyf3a0zbh1grc1vr9zzpqm5yfcjvn0f1akw9l1arq36isqwvydn";
  };
  sourceRoot = "source/gremlin-python/src/main/python";
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pytest-runner==5.2' ' '
  '';

  # setup-requires requirements
  nativeBuildInputs = [
    importlib-metadata
  ];
  propagatedBuildInputs = [
    aenum
    aiohttp
    isodate
    nest-asyncio
    six
  ];

  checkInputs = [
    pytestCheckHook
    mock
    pyhamcrest
    radish-bdd
  ];

  # disable custom pytest report generation
  preCheck = ''
    substituteInPlace setup.cfg --replace 'addopts' '#addopts'
    export TEST_TRANSACTIONS='false'
  '';

  # many tests expect a running tinkerpop server
  disabledTestPaths = [
    "tests/driver/test_client.py"
    "tests/driver/test_driver_remote_connection.py"
    "tests/driver/test_driver_remote_connection_threaded.py"
    "tests/process/test_dsl.py"
    "tests/structure/io/test_functionalityio.py"
  ];
  pytestFlagsArray = [
    # disabledTests doesn't quite allow us to be precise enough for this
    "-k 'not (TestFunctionalGraphSONIO and (test_timestamp or test_datetime or test_uuid))'"
  ];

  meta = with lib; {
    description = "Gremlin-Python implements Gremlin, the graph traversal language of Apache TinkerPop, within the Python language";
    homepage = "https://tinkerpop.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ turion ris ];
  };
}
