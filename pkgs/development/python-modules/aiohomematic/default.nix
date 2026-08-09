{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  openccu-data,
  orjson,
  pydantic,
  pydevccu,
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
  version = "2026.8.1";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "aiohomematic";
    tag = finalAttrs.version;
    hash = "sha256-O+6affSwOgIXrIeUmpiKaON6AO6QXVi4zmOuXBnz+3A=";
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
    pydevccu
    pytest-asyncio
    pytest-xdist
    pytest-socket
    pytestCheckHook
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
