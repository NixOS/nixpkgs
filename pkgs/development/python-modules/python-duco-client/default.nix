{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-duco-client";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldvdmeer";
    repo = "python-duco-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-259aAdOltH/Yr+acIhFCe6M/JXCUQS80e8b15wlnVQM=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "duco" ];

  meta = {
    description = "Async Python client for the Duco ventilation API";
    homepage = "https://github.com/ronaldvdmeer/python-duco-client";
    changelog = "https://github.com/ronaldvdmeer/python-duco-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
