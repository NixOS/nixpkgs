{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
, six
, pytestCheckHook
, pretend
, setuptools
}:

buildPythonPackage rec {
  pname = "packaging";
  version = "21.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3UfEKSfYmrkR5gZRiQfMLTofOLvQJjhZcGQ/nFuOz+s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ pyparsing six ];

  checkInputs = [
    pytestCheckHook
    pretend
  ];

  # Prevent circular dependency
  doCheck = false;

  meta = with lib; {
    description = "Core utilities for Python packages";
    homepage = "https://github.com/pypa/packaging";
    license = [ licenses.bsd2 licenses.asl20 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
