{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  writableTmpDirAsHomeHook,

  # build-system
  packaging,
  setuptools,

  # dependencies
  h5netcdf,
  matplotlib,
  numpy,
  pandas,
  platformdirs,
  scipy,
  typing-extensions,
  xarray,
  xarray-einstats,

  # tests
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

buildPythonPackage (finalAttrs: {
  pname = "arviz";
  version = "0.23.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YQ5i+CSuznbWAQ29jgqrOs+zgOAS5U4wSNEIquJQkvY=";
  };

  nativeBuildInputs = [
    # Arviz wants to write a stamp file to the homedir at import time.
    # Without $HOME being writable, `pythonImportsCheck` fails.
    # https://github.com/arviz-devs/arviz/commit/4db612908f588d89bb5bfb6b83a08ada3d54fd02
    writableTmpDirAsHomeHook
  ];

  build-system = [
    packaging
    setuptools
  ];

  dependencies = [
    h5netcdf
    h5py
    matplotlib
    numpy
    pandas
    platformdirs
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

  enabledTestPaths = [
    "arviz/tests/base_tests/"
  ];

  disabledTestPaths = [
    # AttributeError: module 'zarr.storage' has no attribute 'DirectoryStore'
    # https://github.com/arviz-devs/arviz/issues/2357
    "arviz/tests/base_tests/test_data_zarr.py::TestDataZarr::test_io_function"
    "arviz/tests/base_tests/test_data_zarr.py::TestDataZarr::test_io_method"
  ];

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
    changelog = "https://github.com/arviz-devs/arviz/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ omnipotententity ];
  };
})
