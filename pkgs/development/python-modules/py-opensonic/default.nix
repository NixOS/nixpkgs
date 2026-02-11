{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  mashumaro,
  requests,
}:

buildPythonPackage rec {
  pname = "py-opensonic";
  version = "8.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    tag = "v${version}";
    hash = "sha256-/P/7ytA0YHuJZEq7KQosPBQM2vo6VAss1G8pTIEswJA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
    requests
  ];

  doCheck = false; # no tests

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
