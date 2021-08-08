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
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "109cd585cac41297f71103c3c42ac6ef7379f29788eb54cb751be5a663bb235a";
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
