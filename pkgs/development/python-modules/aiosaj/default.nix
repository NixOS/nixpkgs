{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosaj";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rsarrechia";
    repo = "aiosaj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9eYaRHepiv2FjgOu5vw0Fth9fVg7EHUPZgvuPuhaCng=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiosaj" ];

  meta = {
    description = "Async library to read data from SAJ solar inverters";
    homepage = "https://github.com/Rsarrechia/aiosaj";
    changelog = "https://github.com/Rsarrechia/aiosaj/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
