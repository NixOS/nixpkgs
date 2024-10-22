{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-requirements-txt,
  mockupdb,
  pymongo,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "motor";
  version = "3.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "motor";
    rev = "refs/tags/${version}";
    hash = "sha256-mg31FzMF0xEEhfLKAdF2pzEkULESFFGaXnE0uospXqE=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = [ pymongo ];

  nativeCheckInputs = [ mockupdb ];

  # network connections
  doCheck = false;

  pythonImportsCheck = [ "motor" ];

  meta = {
    description = "Non-blocking MongoDB driver for Tornado or asyncio";
    license = lib.licenses.asl20;
    homepage = "https://github.com/mongodb/motor";
    maintainers = with lib.maintainers; [ globin ];
  };
}
