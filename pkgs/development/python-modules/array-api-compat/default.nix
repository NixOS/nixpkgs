{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  array-api-strict,
  dask,
  jax,
  jaxlib,
  numpy,
  pytestCheckHook,
  sparse,
  torch,
  cupy,

  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage rec {
  pname = "array-api-compat";
  version = "1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "data-apis";
    repo = "array-api-compat";
    tag = version;
    hash = "sha256-Dhiq6GWxVm9BEeO81VSa3L644gp00LxFPJAliz8LbAE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    array-api-strict
    dask
    jax
    jaxlib
    numpy
    pytestCheckHook
    sparse
    torch
  ]
  ++ lib.optionals cudaSupport [ cupy ];

  pythonImportsCheck = [ "array_api_compat" ];

  # CUDA (used via cupy) is not available in the testing sandbox
  disabledTests = [
    "cupy"
  ];

  meta = {
    homepage = "https://data-apis.org/array-api-compat";
    changelog = "https://github.com/data-apis/array-api-compat/releases/tag/${src.tag}";
    description = "Compatibility layer for NumPy to support the Python array API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ berquist ];
  };
}
