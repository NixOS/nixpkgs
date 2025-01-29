{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pint,
  poetry-core,
  psychrolib,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyweatherflowudp";
  version = "1.4.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "briis";
    repo = "pyweatherflowudp";
    tag = "v${version}";
    hash = "sha256-aTwGFYTtd07BsWFaFc7ns+8oh2AxTUfRFSu81Zv5OoA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pint
    psychrolib
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyweatherflowudp" ];

  disabledTests = [
    # Tests require network access
    "test_flow_control"
    "test_listen_and_stop"
    "test_repetitive_listen_and_stop"
    "test_process_message"
    "test_listener_connection_errors"
    "test_invalid_messages"
  ];

  meta = with lib; {
    description = "Library to receive UDP Packets from Weatherflow Weatherstations";
    homepage = "https://github.com/briis/pyweatherflowudp";
    changelog = "https://github.com/briis/pyweatherflowudp/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
