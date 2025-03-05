{
  lib,
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
  pymc,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "nutpie";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "nutpie";
    tag = "v${version}";
    hash = "sha256-6D+6+GbtTw4piWFseigEHK7PxmCHXKS0pgW6PrkLPg4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-kmssvkrB44mCvNw54LominTNRhgUI6KFaRYjzKy+eNo=";
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
    pytestCheckHook
    setuptools
    writableTmpDirAsHomeHook
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
