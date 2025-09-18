{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-freezer,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  requests-mock,
  setuptools-scm,
  setuptools,
  syrupy,
  websocket-client,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "devolo-home-control-api";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_home_control_api";
    tag = "v${version}";
    hash = "sha256-eBJ6hdxUplc1poh7WFACWkyfReSdRSyCEoq2A6Sudgg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    python-dateutil
    requests
    zeroconf
    websocket-client
  ];

  nativeCheckInputs = [
    pytest-freezer
    pytest-mock
    pytestCheckHook
    requests-mock
    syrupy
  ];

  pytestFlags = [
    "--snapshot-update"
  ];

  disabledTests = [
    # Disable test that requires network access
    "test__on_pong"
    "TestMprm"
  ];

  pythonImportsCheck = [ "devolo_home_control_api" ];

  meta = with lib; {
    description = "Python library to work with devolo Home Control";
    homepage = "https://github.com/2Fake/devolo_home_control_api";
    changelog = "https://github.com/2Fake/devolo_home_control_api/blob/${src.tag}/docs/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
