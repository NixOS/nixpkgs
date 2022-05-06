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
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-n/o79AXBLFxr6ekuIr67arLJG5wy9FsPDJOvRzJpq1w=";
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
