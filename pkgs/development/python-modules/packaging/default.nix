{ lib
, buildPythonPackage
, fetchFromPyPI
, pyparsing
, six
, pytestCheckHook
, pretend
, setuptools
}:

buildPythonPackage rec {
  pname = "packaging";
  version = "20.9";
  format = "pyproject";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "sha256-WzJ6wTINyGPcpy9FFOzAhvMRhnRLhKIwN0zB/Xdv6uU=";
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
