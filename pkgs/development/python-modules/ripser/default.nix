{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, numpy
, scipy
, scikitlearn
, persim
, pytest
}:

buildPythonPackage rec {
  pname = "ripser";
  version = "0.5.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a54750427e3f1bbb26c625075c831314760a9e5b5bcd3b797df668f020c9eb6";
  };

  checkInputs = [
    pytest
  ];

  requiredPythonModules = [
    cython
    numpy
    scipy
    scikitlearn
    persim
  ];

  checkPhase = ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc

    pytest
  '';

  meta = with lib; {
    description = "A Lean Persistent Homology Library for Python";
    homepage = "https://ripser.scikit-tda.org";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
