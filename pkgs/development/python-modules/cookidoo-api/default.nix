{
  aiofiles,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  isodate,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cookidoo-api";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miaucl";
    repo = "cookidoo-api";
    tag = version;
    hash = "sha256-EWAD33ZF1k76FujQdgBaIzx06zmqh0CfdpknWrs0YLU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    isodate
  ];

  pythonImportsCheck = [ "cookidoo_api" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    python-dotenv
  ];

  meta = {
    changelog = "https://github.com/miaucl/cookidoo-api/releases/tag/${src.tag}";
    description = "Unofficial package to access Cookidoo";
    homepage = "https://github.com/miaucl/cookidoo-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
