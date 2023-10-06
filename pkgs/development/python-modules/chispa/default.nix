{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "chispa";
  version = "0.9.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MrPowers";
    repo = "chispa";
    rev = "refs/tags/v${version}";
    hash = "sha256-C+fodrQ7PztGzFHAi9SF+rkwtf4bdjDE2u0uORDXBbE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    setuptools
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
