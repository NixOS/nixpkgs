{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
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
  version = "1.4.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eVE8FrD0YHoRreY9CrNb8v4v4KrG83ZU0oFz+V+p+Q0=";
  };

  propagatedBuildInputs = [
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
    "test_grade_projection"
    "test_multiple_grade_projection"
    "test_inverse"
    "test_inv_g4"
  ];

  disabledTestPaths = [
    # Disable failing tests
    "test_g3c_tools.py"
    "test_multivector_inverse.py"
  ];

  pythonImportsCheck = [ "clifford" ];

  meta = with lib; {
    description = "Numerical Geometric Algebra Module";
    homepage = "https://clifford.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
