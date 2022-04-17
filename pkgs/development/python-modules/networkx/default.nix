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
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0RlLp1Pl7tB83s0dI8XNejx3IJm9jb0v6jZniM9N57o=";
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
