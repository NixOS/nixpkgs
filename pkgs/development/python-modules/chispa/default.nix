{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  setuptools,
  prettytable,
}:

buildPythonPackage rec {
  pname = "chispa";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MrPowers";
    repo = "chispa";
    tag = "v${version}";
    hash = "sha256-M4iYKWXI0wBSHt1tWd0vGvQ6FLRRE9TB2u6sTJnkFpY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    setuptools
    prettytable
  ];

  # Tests require a spark installation
  doCheck = false;

  # pythonImportsCheck needs spark installation

  meta = {
    description = "PySpark test helper methods with beautiful error messages";
    homepage = "https://github.com/MrPowers/chispa";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ratsclub ];
  };
}
