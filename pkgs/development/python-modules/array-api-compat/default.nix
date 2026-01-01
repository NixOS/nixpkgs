{
  lib,
<<<<<<< HEAD
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
=======
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  numpy,
  jaxlib,
  jax,
  torch,
  dask,
  sparse,
  array-api-strict,
  config,
  cudaSupport ? config.cudaSupport,
  cupy,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "array-api-compat";
<<<<<<< HEAD
  version = "1.13";
=======
  version = "1.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "data-apis";
    repo = "array-api-compat";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-4ZoYtqkY/xPRyBP1xeMR80zMfwiaKtXX/3XzqiweCtc=";
=======
    hash = "sha256-Hb0bFjVMl4CBI3gN3abTO2QUPAOvUaFE0GdPjdops5E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    array-api-strict
    dask
    jax
    jaxlib
    numpy
    pytestCheckHook
    sparse
    torch
=======
    pytestCheckHook
    numpy
    jaxlib
    jax
    torch
    dask
    sparse
    array-api-strict
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
