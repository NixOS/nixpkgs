{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
, six
, pytestCheckHook
, pretend
, flit-core
}:

buildPythonPackage rec {
  pname = "packaging";
  version = "20.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "Ba87uF0yA3fbKBzyVKsFDhp+vL9UEGhamkB+GKH4EjY=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [ pyparsing six ];

  checkInputs = [
    pytestCheckHook
    pretend
  ];

  checkPhase = ''
    py.test tests
  '';

  # Prevent circular dependency
  doCheck = false;

  meta = with lib; {
    description = "Core utilities for Python packages";
    homepage = "https://github.com/pypa/packaging";
    license = [ licenses.bsd2 licenses.asl20 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
