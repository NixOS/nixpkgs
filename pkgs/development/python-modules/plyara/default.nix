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
  version = "2.2.2";
  pyproject = true;

  disabled = pythonOlder "3.10"; # https://github.com/plyara/plyara: "Plyara requires Python 3.10+"

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AIxXtu9Ic0N8I29w2h/sP5EdWsscmWza9WkhVyvlSs0=";
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
