{ lib
, buildPythonPackage
, fetchFromGitHub
, aenum
, importlib-metadata
, isodate
, six
, tornado
, pytestCheckHook
, mock
, pyhamcrest
, radish-bdd
}:

buildPythonPackage rec {
  pname = "gremlinpython";
  version = "3.4.10";

  # pypi tarball doesn't include tests
  src = fetchFromGitHub {
    owner = "apache";
    repo = "tinkerpop";
    rev = version;
    sha256 = "0i9lkrwbsmpx1h9480vf97pibm2v37sgw2qm2r1c0i8gg5bcmhj3";
  };
  sourceRoot = "source/gremlin-python/src/main/jython";
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'aenum>=1.4.5,<3.0.0' 'aenum' \
      --replace 'tornado>=4.4.1,<6.0' 'tornado' \
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
    isodate
    six
    tornado
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
