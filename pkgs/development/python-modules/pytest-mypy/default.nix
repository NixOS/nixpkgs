{ lib
, buildPythonPackage
, fetchPypi
, filelock
, pytest
, mypy
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63d418a4fea7d598ac40b659723c00804d16a251d90a5cfbca213eeba5aaf01c";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ pytest mypy filelock ];

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
