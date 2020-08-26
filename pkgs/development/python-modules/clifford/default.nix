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
  version = "1.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ade11b20d0631dfc9c2f18ce0149f1e61e4baf114108b27cfd68e5c1619ecc0c";
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
    homepage = "https://clifford.readthedocs.io";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
