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
  version = "9.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    tag = "v${version}";
    hash = "sha256-xZHlI62QoKkR4sZf0GUEzUGMpG2urHooPs8GvVyqpIQ=";
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
