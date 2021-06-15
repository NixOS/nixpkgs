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
  version = "0.6.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c47deffbf9e163186b0997f2d59486d96a7c65766e76500f754fadfbc89f5d9";
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
