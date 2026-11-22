{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  godevccu,
  openccu-data,
  orjson,
  pydantic,
  pytest-asyncio,
  pytest-socket,
  pytest-xdist,
  pytestCheckHook,
  python-slugify,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohomematic";
  version = "2026.11.2";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "aiohomematic";
    tag = finalAttrs.version;
    hash = "sha256-V25fbyrT+MgyL04H1Vmb1rB6et1+K/c/18rHopgdCfM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    openccu-data
    orjson
    pydantic
    python-slugify
  ];

  nativeCheckInputs = [
    freezegun
    godevccu
    pytest-asyncio
    pytest-xdist
    pytest-socket
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = [
    "tests/benchmarks"
  ];

  pythonImportsCheck = [ "aiohomematic" ];

  meta = {
    description = "Module to interact with HomeMatic devices";
    homepage = "https://github.com/SukramJ/aiohomematic";
    changelog = "https://github.com/SukramJ/aiohomematic/blob/${finalAttrs.src.tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      fab
    ];
  };
})
