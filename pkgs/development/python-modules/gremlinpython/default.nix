{ lib
, buildPythonPackage
, fetchFromGitHub
, aenum
, aiohttp
, importlib-metadata
, isodate
, nest-asyncio
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mock
, pyhamcrest
, radish-bdd
}:

buildPythonPackage rec {
  pname = "gremlinpython";
<<<<<<< HEAD
  version = "3.6.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tinkerpop";
    rev = "refs/tags/${version}";
    hash = "sha256-SQ+LcHeHDB1Hd5wXGDJBZmBG4KEZ3NsV4+4X9WgPb9E=";
  };

  sourceRoot = "${src.name}/gremlin-python/src/main/python";
=======
  version = "3.6.1";

  # pypi tarball doesn't include tests
  src = fetchFromGitHub {
    owner = "apache";
    repo = "tinkerpop";
    rev = version;
    hash = "sha256-FMA9hJdq7gYkDtQO04Bwpjq2Q7nXGuN9wrBD4b9GgwY=";
  };

  sourceRoot = "source/gremlin-python/src/main/python";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    sed -i '/pytest-runner/d' setup.py

    substituteInPlace setup.py \
<<<<<<< HEAD
=======
      --replace 'aiohttp>=3.8.0,<=3.8.1' 'aiohttp' \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --replace 'importlib-metadata<5.0.0' 'importlib-metadata' \
      --replace "os.getenv('VERSION', '?').replace('-SNAPSHOT', '.dev-%d' % timestamp)" '"${version}"'
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
  ];

  nativeCheckInputs = [
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ris ];
=======
    maintainers = with maintainers; [ turion ris ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
