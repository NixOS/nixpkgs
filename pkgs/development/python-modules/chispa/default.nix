{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "chispa";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MrPowers";
    repo = "chispa";
    rev = "refs/tags/v${version}";
    hash = "sha256-r3/Uae/Bu/+ZpWt19jetfIRpew1hBB24WWQRJIcYqFs=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ setuptools ];

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
