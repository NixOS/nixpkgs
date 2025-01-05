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
  version = "1.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymatting";
    repo = "pymatting";
    # https://github.com/pymatting/pymatting/issues/92
    rev = "afd2dec073cb08b8119300feec18c179a9d436f3";
    hash = "sha256-AzdhRZgcT+gfLPZYKJLQUW7uLyXoRy6SP2raHWd9XUY=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
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

  meta = with lib; {
    description = "Python library for alpha matting";
    homepage = "https://github.com/pymatting/pymatting";
    changelog = "https://github.com/pymatting/pymatting/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
