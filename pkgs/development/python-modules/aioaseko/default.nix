{
  lib,
  aiohttp,
  apischema,
  buildPythonPackage,
  fetchFromGitHub,
  gql,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioaseko";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "Module to interact with the Aseko Pool Live API";
    homepage = "https://github.com/milanmeu/aioaseko";
    changelog = "https://github.com/milanmeu/aioaseko/releases/tag/v${version}";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
