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
  version = "10.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    tag = "v${version}";
    hash = "sha256-sC6dP6SBdgvDVAOlM0c91n8RYfV1kp5IHk8xGqL7kCQ=";
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
