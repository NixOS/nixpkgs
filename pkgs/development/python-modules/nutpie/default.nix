{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # build-system
  cargo,
  rustc,

  # buildInputs
  libiconv,

  # dependencies
  arviz,
  pandas,
  pyarrow,
  xarray,

  # tests
  # bridgestan, (not packaged)
  jax,
  jaxlib,
  numba,
  pymc,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nutpie";
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "nutpie";
    rev = "refs/tags/v${version}";
    hash = "sha256-XyUMCnHm5V7oFaf3W+nGpcHfq1ZFppeGMIMCU5OB87s=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-9lM1S42Bmnlb0opstZN2aOKYhBnP87Frq+fQxk0ez+c=";
  };

  build-system = [
    cargo
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
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
    numba
    jax
    jaxlib
    pymc
    pytestCheckHook
    setuptools
  ];

  disabledTestPaths = [
    # Require unpackaged bridgestan
    "tests/test_stan.py"

    # KeyError: "duplicate registration for <class 'numba.core.types.misc.SliceType'>"
    "tests/test_pymc.py"
  ];

  # Currently, no test are working...
  doCheck = false;

  meta = {
    description = "Python wrapper for nuts-rs";
    homepage = "https://github.com/pymc-devs/nutpie";
    changelog = "https://github.com/pymc-devs/nutpie/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
