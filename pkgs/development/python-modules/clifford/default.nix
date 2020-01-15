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
  version = "1.0.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fc5aa76b4f73c697c0ebd2f86c5233e7ca0a5109b80147f4e711bc3de4b3f2c";
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
