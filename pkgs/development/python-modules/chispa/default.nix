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
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MrPowers";
    repo = "chispa";
    tag = "v${version}";
    hash = "sha256-G65+3GbIGNwZVSFc89tXlYgPimtJPFo9ZK23fZgrCF4=";
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
