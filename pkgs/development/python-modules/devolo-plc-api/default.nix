{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, protobuf
, pytest-asyncio
, pytest-httpx
, pytest-mock
, pytestCheckHook
, pythonOlder
, segno
, setuptools-scm
, syrupy
, zeroconf
}:

buildPythonPackage rec {
  pname = "devolo-plc-api";
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_plc_api";
    rev = "refs/tags/v${version}";
    hash = "sha256-EP99AswHmLO+8ZQAPjJyw/P9QqfDawy3AqyJR870Qms=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "protobuf>=4.22.0" "protobuf"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    httpx
    protobuf
    segno
    zeroconf
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
    syrupy
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
