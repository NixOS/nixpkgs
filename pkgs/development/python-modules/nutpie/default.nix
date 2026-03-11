{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # build-system
  cargo,
  rustc,

  # dependencies
  arro3-core,
  arviz,
  obstore,
  pandas,
  pyarrow,
  xarray,
  zarr,

  # tests
  # bridgestan, (not packaged)
  equinox,
  flowjax,
  jax,
  jaxlib,
  numba,
  pytest-timeout,
  pymc,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nutpie";
  version = "0.16.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "nutpie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pZlUS8Rd8uNAau7q3yogtdRUvDkN8MiTWj+3lZolBSY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-F9WuFPyJd7IVaboUHnFpf3GiLB5AWap8RBScuqlZB3s=";
  };

  build-system = [
    cargo
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [
    arro3-core
    arviz
    obstore
    pandas
    pyarrow
    xarray
    zarr
  ];

  pythonImportsCheck = [ "nutpie" ];

  nativeCheckInputs = [
    # bridgestan
    equinox
    flowjax
    numba
    jax
    jaxlib
    pymc
    pytest-timeout
    pytestCheckHook
    setuptools
    writableTmpDirAsHomeHook
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # flaky (assert np.float64(0.0017554642626285276) > 0.01)
    "test_normalizing_flow"
  ];

  disabledTestPaths = [
    # Require unpackaged bridgestan
    "tests/test_stan.py"
  ];

  meta = {
    description = "Python wrapper for nuts-rs";
    homepage = "https://github.com/pymc-devs/nutpie";
    changelog = "https://github.com/pymc-devs/nutpie/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
