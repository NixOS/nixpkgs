{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numba,
  numpy,
  pillow,
  pytestCheckHook,
  scipy,
  setuptools,
  config,
  cudaSupport ? config.cudaSupport,
  cupy,
  pyopencl,
}:

buildPythonPackage rec {
  pname = "pymatting";
  version = "1.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymatting";
    repo = "pymatting";
    tag = "v${version}";
    hash = "sha256-rcatlQE+YgppY//ZgGY9jO5KI0ED30fLlqW9N+xRNqk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numba
    numpy
    pillow
    scipy
  ]
  ++ lib.optionals cudaSupport [
    cupy
    pyopencl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pymatting" ];

  disabledTests = [
    # no access to input data set
    # see: https://github.com/pymatting/pymatting/blob/master/tests/download_images.py
    "test_alpha"
    "test_laplacians"
    "test_preconditioners"
    "test_lkm"
  ];

  # pyopencl._cl.LogicError: clGetPlatformIDs failed: PLATFORM_NOT_FOUND_KHR
  disabledTestPaths = lib.optional cudaSupport "tests/test_foreground.py";

  meta = {
    description = "Python library for alpha matting";
    homepage = "https://github.com/pymatting/pymatting";
    changelog = "https://github.com/pymatting/pymatting/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
