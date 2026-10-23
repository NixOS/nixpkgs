{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  meson-python,

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

buildPythonPackage (finalAttrs: {
  pname = "array-api-compat";
  version = "1.15";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "data-apis";
    repo = "array-api-compat";
    tag = finalAttrs.version;
    hash = "sha256-z6B+lOYciT71Uz3Py9M/8x7R+8IZ46nd8i8AYot5Rlo=";
  };

  build-system = [
    meson-python
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

  # Otherwise, cupy will try to write in $HOME (/homeless-shelter)
  preCheck = ''
    export CUPY_CACHE_DIR=$(mktemp -d)
  '';

  disabledTests = [
    # CUDA (used via cupy) is not available in the testing sandbox
    "cupy"

    # ValueError: api_version='2024.12' is not available; available versions are: ['2025.12']
    "test_array_namespace[jax.numpy-2024.12-False]"
    "test_array_namespace[jax.numpy-2024.12-None]"
  ];

  meta = {
    description = "Compatibility layer for NumPy to support the Python array API";
    homepage = "https://data-apis.org/array-api-compat";
    changelog = "https://github.com/data-apis/array-api-compat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ berquist ];
  };
})
