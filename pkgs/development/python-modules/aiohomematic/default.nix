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

buildPythonPackage rec {
  pname = "aiohomematic";
  version = "2026.5.11";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "aiohomematic";
    tag = version;
    hash = "sha256-Ua7/sLhL0mbZvJwx+TNfXoP+z+jE2TyCO3DqsFpPe6A=";
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
    changelog = "https://github.com/SukramJ/aiohomematic/blob/${src.tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      fab
    ];
  };
}
