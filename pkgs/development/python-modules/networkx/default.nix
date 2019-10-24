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
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r2wr7aqay9fwjrgk35fkjzk8lvvb4i4df7ndaqzkr4ndw5zzx7q";
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
