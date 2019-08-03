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
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff9f50fba911f0e9212077b78014f83e30c97526194dd6bd1df3d81896e6cb58";
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
    homepage = https://ripser.scikit-tda.org;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
