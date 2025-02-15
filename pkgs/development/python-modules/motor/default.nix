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
  version = "3.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "motor";
    tag = version;
    hash = "sha256-9U1dUkjhsQ1PkeXfqFCRL8DOJ2xTRzH9lc/inm8gyIY=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  pythonRelaxDeps = [ "pymongo" ];

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
