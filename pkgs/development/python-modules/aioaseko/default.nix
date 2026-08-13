{
  lib,
  aiohttp,
  apischema,
  buildPythonPackage,
  fetchFromGitHub,
  gql,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioaseko";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = "aioaseko";
    tag = "v${version}";
    hash = "sha256-jUvpu/lOFKRUwEuYD1zRp0oODjf4AgH84fnGngtv9jw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    apischema
    gql
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioaseko" ];

  meta = {
    description = "Module to interact with the Aseko Pool Live API";
    homepage = "https://github.com/milanmeu/aioaseko";
    changelog = "https://github.com/milanmeu/aioaseko/releases/tag/v${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
