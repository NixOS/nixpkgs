{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  packaging,
  setuptools,

  # dependencies
  h5netcdf,
  matplotlib,
  numpy,
  pandas,
  scipy,
  typing-extensions,
  xarray,
  xarray-einstats,

  # checks
  bokeh,
  cloudpickle,
  emcee,
  ffmpeg,
  h5py,
  jax,
  jaxlib,
  numba,
  numpyro,
  #, pymc3 (circular dependency)
  pyro-ppl,
  #, pystan (not packaged)
  pytestCheckHook,
  torchvision,
  zarr,
}:

buildPythonPackage rec {
  pname = "arviz";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz";
    rev = "refs/tags/v${version}";
    hash = "sha256-6toqOGwk8YbatfiDCTEG4r0z3zZAA8zcNVZJqqssYrY=";
  };

  build-system = [
    packaging
    setuptools
  ];

  dependencies = [
    h5netcdf
    matplotlib
    numpy
    pandas
    scipy
    typing-extensions
    xarray
    xarray-einstats
  ];

  nativeCheckInputs = [
    bokeh
    cloudpickle
    emcee
    ffmpeg
    h5py
    jax
    jaxlib
    numba
    numpyro
    # pymc3 (circular dependency)
    pyro-ppl
    # pystan (not packaged)
    pytestCheckHook
    torchvision
    zarr
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [ "arviz/tests/base_tests/" ];

  disabledTests = [
    # Tests require network access
    "test_plot_ppc_transposed"
    "test_plot_separation"
    "test_plot_trace_legend"
    "test_cov"
    # countourpy is not available at the moment
    "test_plot_kde"
    "test_plot_kde_2d"
    "test_plot_pair"
  ];

  # Tests segfault on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "arviz" ];

  meta = {
    description = "Library for exploratory analysis of Bayesian models";
    homepage = "https://arviz-devs.github.io/arviz/";
    changelog = "https://github.com/arviz-devs/arviz/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ omnipotententity ];
  };
}
