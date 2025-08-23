{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  protobuf,
  pytest-asyncio_0,
  pytest-httpx,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  segno,
  setuptools-scm,
  syrupy,
  tenacity,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "devolo-plc-api";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_plc_api";
    tag = "v${version}";
    hash = "sha256-bmZcjvqZwVJzDsdtSbQvJpry2QSSuB6/jOTWG1+jyV4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "protobuf>=4.22.0" "protobuf"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    httpx
    protobuf
    segno
    tenacity
    zeroconf
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio_0
    pytest-httpx
    pytest-mock
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # pytest-httpx compat issue
    "test_wrong_password_type"
  ];

  pythonImportsCheck = [ "devolo_plc_api" ];

  meta = with lib; {
    description = "Module to interact with Devolo PLC devices";
    homepage = "https://github.com/2Fake/devolo_plc_api";
    changelog = "https://github.com/2Fake/devolo_plc_api/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
