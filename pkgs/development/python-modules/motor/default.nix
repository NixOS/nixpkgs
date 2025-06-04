{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-requirements-txt,
  mockupdb,
  pymongo,
}:

buildPythonPackage rec {
  pname = "motor";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "motor";
    tag = version;
    hash = "sha256-O3MHVzL/ECO0vnzJItXTDmmMN8aicbvh0Sve/HlAlZw=";
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
    changelog = "https://github.com/mongodb/motor/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ globin ];
  };
}
