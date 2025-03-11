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
  version = "2.2.8";
  pyproject = true;

  disabled = pythonOlder "3.10"; # https://github.com/plyara/plyara: "Plyara requires Python 3.10+"

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zmpb5r3BcveLsQ0uIgQJx2vUaz2p/0PlO76E0e7elwA=";
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
