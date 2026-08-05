{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-opensonic";
  version = "10.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    tag = "v${version}";
    hash = "sha256-FEoRN2ba54ClSnl9A+yFUEMdsH1rww4321OpDXL9bvY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonRelaxDeps = [
    "mashumaro"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "libopensonic"
  ];

  meta = {
    description = "Python library to wrap the Open Subsonic REST API";
    homepage = "https://github.com/khers/py-opensonic";
    changelog = "https://github.com/khers/py-opensonic/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
