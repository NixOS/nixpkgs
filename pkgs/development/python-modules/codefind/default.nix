{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "codefind";
  version = "0.1.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ouyKLAGAOZ6oON/NzDRMqJ+XuKopO8F7IrLAI6ugb7w=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "codefind" ];

  meta = {
    description = "Find code objects and their referents";
    homepage = "https://github.com/breuleux/codefind";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
