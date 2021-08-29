{ lib
, buildPythonPackage
, fetchPypi
, nose
, decorator
, setuptools
}:

buildPythonPackage rec {
  pname = "networkx";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "12swxb15299v9vqjsq4z8rgh5sdhvpx497xwnhpnb0gynrx6zra5";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ decorator setuptools ];

  meta = {
    homepage = "https://networkx.github.io/";
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}
