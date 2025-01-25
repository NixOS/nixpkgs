{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  ply,
}:

buildPythonPackage rec {
  pname = "plyara";
  version = "2.2.6";
  pyproject = true;

  disabled = pythonOlder "3.10"; # https://github.com/plyara/plyara: "Plyara requires Python 3.10+"

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-228fhwJTEV1kpIxbDzG+CgJOHJjWifl5SYteCY8Pd3Y=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ply
  ];

  pythonImportsCheck = [
    "plyara"
  ];

  meta = {
    description = "Parse YARA rules";
    homepage = "https://pypi.org/project/plyara/";
    changelog = "https://github.com/plyara/plyara/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _13621 ];
  };
}
