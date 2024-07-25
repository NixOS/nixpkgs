{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  h5py,
  ipython,
  numba,
  numpy,
  pytestCheckHook,
  setuptools,
  scipy,
  sparse,
}:

buildPythonPackage rec {
  pname = "clifford";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eVE8FrD0YHoRreY9CrNb8v4v4KrG83ZU0oFz+V+p+Q0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    h5py
    numba
    numpy
    scipy
    sparse
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/pygae/clifford/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    # Broken with numba >= 0.54
    # see https://github.com/pygae/clifford/issues/430
    broken = versionAtLeast numba.version "0.58";
  };
}
