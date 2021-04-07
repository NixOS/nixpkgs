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
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7978955423fbc9639c10498878be59caf99b44dc304c2286162fd24b458c1602";
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
