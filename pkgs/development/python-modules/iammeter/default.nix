{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "iammeter";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lewei50";
    repo = "iammeter_pip_lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DzqJ0F1KHu755IxcNW4GqhXg0CsfZEGJf34W3TbY5GA=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "iammeter" ];

  meta = {
    description = "Module to work with the IamMeter API";
    homepage = "https://github.com/lewei50/iammeter_pip_lib";
    changelog = "https://github.com/lewei50/iammeter_pip_lib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
