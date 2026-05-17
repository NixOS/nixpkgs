{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "life360";
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pnbruckner";
    repo = "life360";
    tag = "v${version}";
    hash = "sha256-D7ZtC9WrGTuU7cOs37P+y9zqOrOlfa919FVicejy6n4=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "life360" ];

  meta = {
    description = "Module to interact with Life360";
    homepage = "https://github.com/pnbruckner/life360";
    changelog = "https://github.com/pnbruckner/life360/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
