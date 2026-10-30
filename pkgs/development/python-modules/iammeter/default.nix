{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "iammeter";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lewei50";
    repo = "iammeter_pip_lib";
    tag = "v${version}";
    hash = "sha256-DzqJ0F1KHu755IxcNW4GqhXg0CsfZEGJf34W3TbY5GA=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    voluptuous
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "iammeter" ];

  meta = {
    description = "Module to work with the IamMeter API";
    homepage = "https://github.com/lewei50/iammeter_pip_lib";
    changelog = "https://github.com/lewei50/iammeter_pip_lib/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
