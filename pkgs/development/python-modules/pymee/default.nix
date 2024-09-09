{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  websockets,
}:

buildPythonPackage rec {
  pname = "pymee";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FreshlyBrewedCode";
    repo = "pymee";
    rev = "refs/tags/v${version}";
    hash = "sha256-4XKd0lZ6RAsG2zXjKMUeST6cNcg+SjT371gxLIhxkAA=";
  };

  build-system = [ setuptools ];
  dependencies = [
    aiohttp
    websockets
  ];

  pythonImportsCheck = [ "pymee" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Python library to interact with homee";
    homepage = "https://github.com/FreshlyBrewedCode/pymee";
    changelog = "https://github.com/FreshlyBrewedCode/pymee/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
