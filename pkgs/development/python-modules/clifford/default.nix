{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy27
, future
, h5py
, ipython
, numba
, numpy
, pytestCheckHook
, scipy
, sparse
}:

buildPythonPackage rec {
  pname = "clifford";
  version = "1.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ade11b20d0631dfc9c2f18ce0149f1e61e4baf114108b27cfd68e5c1619ecc0c";
  };
  patches = [ (fetchpatch {
    # Compatibility with h5py 3.
    # Will be included in the next releasse after 1.3.1
    url = "https://github.com/pygae/clifford/pull/388/commits/955d141662c68d3d61aa50a162b39e656684c208.patch";
    sha256 = "00m8ias58xycn5n78sy9wywf4wck1v0gb8gzmg40inzdiha93jyz";
  }) ];

  propagatedBuildInputs = [
    future
    h5py
    numba
    numpy
    scipy
    sparse
  ];

  checkInputs = [
    pytestCheckHook
    ipython
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'numba==0.43'" "'numba'"
  '';

  # avoid collecting local files
  preCheck = ''
    cd clifford/test
  '';

  pytestFlagsArray = [
    "-m \"not veryslow\""
    "--ignore=test_algebra_initialisation.py" # fails without JIT
    "--ignore=test_cga.py"
  ];

  meta = with lib; {
    description = "Numerical Geometric Algebra Module";
    homepage = "https://clifford.readthedocs.io";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
