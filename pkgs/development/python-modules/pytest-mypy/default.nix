{ lib
, buildPythonPackage
, fetchPypi
, filelock
, attrs
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

  propagatedBuildInputs = [ attrs mypy filelock ];

  # does not contain tests
  doCheck = false;
  pythonImportsExtrasCheck = [ "pytest_mypy" ];

  meta = with lib; {
    description = "Mypy static type checker plugin for Pytest";
    homepage = "https://github.com/dbader/pytest-mypy";
    license = licenses.mit;
    maintainers = [ ];
  };
}
