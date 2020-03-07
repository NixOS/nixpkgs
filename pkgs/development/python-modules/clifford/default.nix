{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, numba
, future
, h5py
, nose
, isPy27
}:

buildPythonPackage rec {
  pname = "clifford";
  version = "1.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b27fdec70574ac928c91fe333a70ece153d75cd0499cce09acea5980ae349bee";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    numba
    future
    h5py
  ];

  checkInputs = [
    nose
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace "'numba==0.43'" "'numba'"
  '';

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Numerical Geometric Algebra Module";
    homepage = https://clifford.readthedocs.io;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
