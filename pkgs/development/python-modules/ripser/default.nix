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
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4015b413c24e3074f82f31771b1eb805e054b8cf444db51ce8ca5afa42cf130";
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
