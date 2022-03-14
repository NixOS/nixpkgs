{ lib
, buildPythonPackage
, fetchPypi
, nose
, pytest
, decorator
, setuptools
}:

buildPythonPackage rec {
  pname = "networkx";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7/t9nNXDbh4NM/QqOu9brd5QMFNYJqNn1c9gihcK9RU=";
  };

  propagatedBuildInputs = [ decorator setuptools ];
  checkInputs = [ nose pytest];
  checkPhase = ''
    pytest
  '';

  meta = {
    homepage = "https://networkx.github.io/";
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}
