{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
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
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "array-api-compat";
  version = "1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "data-apis";
    repo = "array-api-compat";
    rev = "refs/tags/${version}";
    hash = "sha256-DZs51yWgeMX7lmzR6jily0S3MRD4AVlk7BP8aU99Zp8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    jaxlib
    jax
    torch
    dask
    sparse
    array-api-strict
  ] ++ lib.optionals cudaSupport [ cupy ];

  pythonImportsCheck = [ "array_api_compat" ];

  # CUDA (used via cupy) is not available in the testing sandbox
  checkPhase = ''
    runHook preCheck
    python -m pytest -k 'not cupy'
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://data-apis.org/array-api-compat";
    changelog = "https://github.com/data-apis/array-api-compat/releases/tag/${version}";
    description = "Compatibility layer for NumPy to support the Python array API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ berquist ];
  };
}
