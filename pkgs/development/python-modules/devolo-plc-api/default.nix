{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, httpx
, protobuf
, pytest-asyncio
, pytest-httpx
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools-scm
, zeroconf
}:

buildPythonPackage rec {
  pname = "devolo-plc-api";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_plc_api";
    rev = "refs/tags/v${version}";
    hash = "sha256-xM7g6q18A+qmOhQeey4uxs6ow6Hf5YKDdbpXwYr2RXo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    httpx
    protobuf
    zeroconf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "devolo_plc_api"
  ];

  meta = with lib; {
    description = "Module to interact with Devolo PLC devices";
    homepage = "https://github.com/2Fake/devolo_plc_api";
    changelog = "https://github.com/2Fake/devolo_plc_api/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
