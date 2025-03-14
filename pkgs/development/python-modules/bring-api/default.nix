{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
  setuptools,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "bring-api";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "miaucl";
    repo = "bring-api";
    tag = version;
    hash = "sha256-GBRPC4oTCTy8MdGNsPYrgB8Lji0ojRL3Z4ELTe543PY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    # https://github.com/miaucl/bring-api/blob/1.0.0/requirements.txt
    # pyproject.toml is out of sync
    aiohttp
    yarl
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    python-dotenv
    syrupy
  ];

  pythonImportsCheck = [ "bring_api" ];

  meta = with lib; {
    description = "Module to access the Bring! shopping lists API";
    homepage = "https://github.com/miaucl/bring-api";
    changelog = "https://github.com/miaucl/bring-api/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
