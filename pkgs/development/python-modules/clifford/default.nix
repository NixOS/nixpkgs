{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, future
, h5py
, numba
, numpy
, scipy
, sparse
, pytestCheckHook
, pytest-benchmark
, ipython
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
    future
    h5py
    numba
    numpy
    scipy
    sparse
  ];

  checkInputs = [
    pytestCheckHook
    pytest-benchmark
    ipython
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'numba==0.43'" "'numba'"
  '';

  pytestFlagsArray = [
    "--pyargs clifford"
    "--benchmark-skip"
    "-m 'not veryslow'"
  ];
  disabledTests = [
    # Slow tests, > 10 seconds
    "test_iterative_model_match"
    "test_estimate_rotor"
    "test_estimate_motor"
    "test_array_control"
    "test_clustering"
    "test_write_and_read"
    "test_assign_objects_to_objects"
    "test_general_logarithm_conformal"
    # Flaky tests
    "test_get_properties_of_sphere"
    "test_get_midpoint_between_lines"
  ];

  meta = with lib; {
    description = "Numerical Geometric Algebra Module";
    homepage = "https://clifford.readthedocs.io";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
