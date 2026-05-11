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
  platformdirs,
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
  version = "0.16.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "nutpie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2SQrdjQil5fNDzlM+2LgBKaOL5wPP5mB89ofBu4XawI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-sUq86CxrCgLAeBspWvTIfHYW6MDOtVoTLdBbCu/Ulj8=";
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
    platformdirs
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
