{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  orjson,
  pydantic,
  pydevccu,
  pytest-asyncio,
  pytest-socket,
  pytest-xdist,
  pytestCheckHook,
  python-slugify,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohomematic";
  version = "2026.2.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "aiohomematic";
    tag = version;
    hash = "sha256-BwEW1U9ARTZ5QQh3XZ1J1zh9/pDCtp4PG6FGAYdxGBg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
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
    changelog = "https://github.com/SukramJ/aiohomematic/blob/${src.tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      fab
    ];
  };
}
