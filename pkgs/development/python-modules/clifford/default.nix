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

  patches = [
    (fetchpatch {
      # Compatibility with h5py 3.
      # Will be included in the next releasse after 1.3.1
      url = "https://github.com/pygae/clifford/pull/388/commits/955d141662c68d3d61aa50a162b39e656684c208.patch";
      sha256 = "0pkpwnk0kfdxsbzsxqlqh8kgif17l5has0mg31g3kyp8lncj89b1";
    })
  ];

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

  # avoid collecting local files
  preCheck = ''
    cd clifford/test
  '';

  disabledTests = [
    "veryslow"
    "test_algebra_initialisation"
    "test_cga"
    "test_estimate_rotor_sequential[random_sphere]"
  ];

  meta = with lib; {
    description = "Numerical Geometric Algebra Module";
    homepage = "https://clifford.readthedocs.io";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
    # many TypeError's in tests
    broken = true;
  };
}
