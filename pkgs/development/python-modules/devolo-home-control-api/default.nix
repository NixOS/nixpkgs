{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, setuptools-scm
, websocket-client
, zeroconf
}:

buildPythonPackage rec {
  pname = "devolo-home-control-api";
  version = "0.18.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_home_control_api";
    rev = "v${version}";
    sha256 = "sha256-H4kLomHM0qq6LqsRMEp34oKy/4Me7AQi6dij2vraBS8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
    zeroconf
    websocket-client
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  # Disable test that requires network access
  disabledTests = [
    "test__on_pong"
    "TestMprm"
  ];

  pythonImportsCheck = [ "devolo_home_control_api" ];

  meta = with lib; {
    description = "Python library to work with devolo Home Control";
    homepage = "https://github.com/2Fake/devolo_home_control_api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
