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
  version = "10.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    tag = "v${version}";
    hash = "sha256-LT6pTtXCUMhk6uV9Y2inlAuP8osWUwsWOH7/yOW2OXI=";
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
