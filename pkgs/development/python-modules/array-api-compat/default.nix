{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
}:

buildPythonPackage rec {
  pname = "array-api-compat";
  version = "1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "data-apis";
    repo = "array-api-compat";
    tag = version;
    hash = "sha256-Hb0bFjVMl4CBI3gN3abTO2QUPAOvUaFE0GdPjdops5E=";
  };

  patches = [
    # Issue: https://github.com/data-apis/array-api-compat/issues/368
    # PR (merged): https://github.com/data-apis/array-api-compat/pull/369
    (fetchpatch {
      name = "fix-jax-0.8.2-compat";
      url = "https://github.com/data-apis/array-api-compat/commit/b61e9c3fbc55e1fb66a63b4d4f333fb04dbd3879.patch";
      hash = "sha256-jNDBmpcn65/qUP0CHnkKBq2VSg068WeAz6D/bxfoGMc=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    jaxlib
    jax
    torch
    dask
    sparse
    array-api-strict
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
