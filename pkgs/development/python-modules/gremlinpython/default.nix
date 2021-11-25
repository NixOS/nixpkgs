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
  version = "3.5.1";

  # pypi tarball doesn't include tests
  src = fetchFromGitHub {
    owner = "apache";
    repo = "tinkerpop";
    rev = version;
    sha256 = "1vlhxq0f2hanhkv6f17dxgbwr7gnbnh1kkkq0lxcwkbm2l0rdrlr";
  };
  sourceRoot = "source/gremlin-python/src/main/python";
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'aenum>=1.4.5,<3.0.0' 'aenum' \
      --replace 'aiohttp>=3.7.0,<=3.7.4' 'aiohttp' \
      --replace 'PyHamcrest>=1.9.0,<2.0.0' 'PyHamcrest' \
      --replace 'radish-bdd==0.8.6' 'radish-bdd' \
      --replace 'mock>=3.0.5,<4.0.0' 'mock' \
      --replace 'pytest>=4.6.4,<5.0.0' 'pytest' \
      --replace 'importlib-metadata<3.0.0' 'importlib-metadata' \
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
