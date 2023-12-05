{ buildPythonPackage
, fetchFromGitHub
, lib
, pythonAtLeast
, pythonOlder

# runtime
, six

# tests
, freezegun
, pytest-mock
, pytestCheckHook
, tornado_4
}:

buildPythonPackage rec {
  pname = "lomond";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "wildfoundry";
    repo = "dataplicity-${pname}";
    rev = "b30dad3cc38d5ff210c5dd01f8c3c76aa6c616d1";
    sha256 = "0lydq0imala08wxdyg2iwhqa6gcdrn24ah14h91h2zcxjhjk4gv8";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    freezegun
    pytest-mock
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.10") [
    tornado_4
  ];

  disabledTests = [
    # Makes HTTP requests
    "test_proxy"
    "test_live"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.10") [
    # requires tornado_4, which is not compatible with python3.10
    "tests/test_integration.py"
  ];

  meta = with lib; {
    description = "Websocket Client Library";
    homepage = "https://github.com/wildfoundry/dataplicity-lomond";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
