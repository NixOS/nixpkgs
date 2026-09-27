{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numba,
  numpy,
  pillow,
  scipy,
  # cuda-only
  cupy,
  pyopencl,

  # tests
  pocl,
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  config,
  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymatting";
  version = "1.1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymatting";
    repo = "pymatting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mc8op6RKnPZruKJup5ybTrX2VBNseN1/WkjRWsqMoWo=";
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

  pythonImportsCheck = [ "pymatting" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.optionals cudaSupport [
    # Provides a CPU-based OpenCL ICD so that pyopencl's module-level
    # cl.create_some_context() succeeds without GPU hardware.
    pocl
    # pocl needs a writable $HOME for its kernel cache directory.
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # no access to input data set
    # see: https://github.com/pymatting/pymatting/blob/master/tests/download_images.py
    "test_alpha"
    "test_laplacians"
    "test_preconditioners"
    "test_lkm"
  ];

  disabledTestPaths = lib.optionals cudaSupport [
    # Requires a CUDA driver for cupy GPU operations
    "tests/test_foreground.py"
  ];

  meta = {
    description = "Python library for alpha matting";
    homepage = "https://github.com/pymatting/pymatting";
    changelog = "https://github.com/pymatting/pymatting/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
