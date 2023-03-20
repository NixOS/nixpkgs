{ lib
, buildPythonPackage
, fetchPypi
, filelock
, pytest
, mypy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+EWPZCMj8Toso+LmFQn3dnlmtSe02K3M1QMsPntP09s=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ mypy filelock ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "pytest_mypy" ];

  meta = with lib; {
    description = "Mypy static type checker plugin for Pytest";
    homepage = "https://github.com/dbader/pytest-mypy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
