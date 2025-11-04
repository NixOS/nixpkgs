{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  orjson,
  pydevccu,
  pytest-asyncio,
  pytest-socket,
  pytestCheckHook,
  python-slugify,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "aiohomematic";
  version = "2025.11.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "aiohomematic";
    tag = version;
    hash = "sha256-bqhuh+9rcqKreZCc3WJPFR1i3Y8mjtLER/bLlbMp6xc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    python-slugify
    voluptuous
  ];

  nativeCheckInputs = [
    freezegun
    pydevccu
    pytest-asyncio
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohomematic" ];

  meta = {
    description = "Module to interact with HomeMatic devices";
    homepage = "https://github.com/SukramJ/aiohomematic";
    changelog = "https://github.com/SukramJ/aiohomematic/blob/${src.tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      fab
    ];
  };
}
