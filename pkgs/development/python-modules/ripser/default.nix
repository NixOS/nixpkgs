{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, numpy
, scipy
, scikit-learn
, persim
, pytest
}:

buildPythonPackage rec {
  pname = "ripser";
  version = "0.6.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "335112a0f94532ccbe686db7826ee8d0714b32f65891abf92c0a02f3cb0fc5fd";
  };

  checkInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    cython
    numpy
    scipy
    scikit-learn
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
