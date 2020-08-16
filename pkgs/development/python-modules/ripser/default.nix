{ lib
, buildPythonPackage
, fetchPypi
, cython
, numpy
, scipy
, scikitlearn
, persim
, pytest
}:

buildPythonPackage rec {
  pname = "ripser";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb63a03205511cd3d2aae586cec9515dddfbec3ce269dd0560911b0a55d75632";
  };

  checkInputs = [
    pytest
  ];

  propagatedBuildInputs = [
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
