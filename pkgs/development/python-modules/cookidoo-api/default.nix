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

buildPythonPackage (finalAttrs: {
  pname = "cookidoo-api";
  version = "0.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miaucl";
    repo = "cookidoo-api";
    tag = finalAttrs.version;
    hash = "sha256-3o+UZmS2Mfymqgl7qa1MSani2O/fiEfvQ0GQp7MBOOg=";
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
    changelog = "https://github.com/miaucl/cookidoo-api/releases/tag/${finalAttrs.src.tag}";
    description = "Unofficial package to access Cookidoo";
    homepage = "https://github.com/miaucl/cookidoo-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
