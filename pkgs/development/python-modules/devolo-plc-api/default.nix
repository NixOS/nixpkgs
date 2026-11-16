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
  segno,
  setuptools-scm,
  syrupy,
  tenacity,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "devolo-plc-api";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_plc_api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GOX4rU26ghmrbx6cKomuW/FzjWuTy3lRmrtiwWuktFE=";
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

  meta = {
    description = "Module to interact with Devolo PLC devices";
    homepage = "https://github.com/2Fake/devolo_plc_api";
    changelog = "https://github.com/2Fake/devolo_plc_api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
