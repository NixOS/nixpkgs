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
  arviz,
  pandas,
  pyarrow,
  xarray,

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

buildPythonPackage rec {
  pname = "nutpie";
  version = "0.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "nutpie";
    tag = "v${version}";
    hash = "sha256-9rcQtEdaafMyuNb/ezcqUmrwXbQFa9hdajGAtANdHOw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-6JWBJYGhSNUL8KYiEE2ZBW9xP4CmkCcwwhsO6aOvZyA=";
  };

  build-system = [
    cargo
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonRelaxDeps = [
    "xarray"
  ];

  dependencies = [
    arviz
    pandas
    pyarrow
    xarray
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

  pytestFlags = [
    "-v"
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
    changelog = "https://github.com/pymc-devs/nutpie/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
