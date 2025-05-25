{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  setuptools,
  prettytable,
}:

buildPythonPackage rec {
  pname = "chispa";
  version = "0.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "PySpark test helper methods with beautiful error messages";
    homepage = "https://github.com/MrPowers/chispa";
    license = licenses.mit;
    maintainers = with maintainers; [ ratsclub ];
  };
}
