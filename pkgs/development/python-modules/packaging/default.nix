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
    sha256 = "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ pyparsing ];

  pythonImportsCheck = [ "pyparsing" ];

  # Prevent circular dependency
  doCheck = false;

  meta = with lib; {
    description = "Core utilities for Python packages";
    homepage = "https://github.com/pypa/packaging";
    license = [ licenses.bsd2 licenses.asl20 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
