{ lib
, buildPythonPackage
, fetchFromGitHub
, emcee
, h5netcdf
, matplotlib
, netcdf4
, numba
, numpy
, pandas
, pytest
, setuptools
, cloudpickle
, pytestCheckHook
, scipy
, packaging
, typing-extensions
, pythonOlder
, xarray
, xarray-einstats
, zarr
, ffmpeg
, h5py
, jaxlib
, torchvision
, jax
  # , pymc3 (circular dependency)
, pyro-ppl
  #, pystan (not packaged)
, numpyro
}:

buildPythonPackage rec {
  pname = "arviz";
  version = "0.16.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kixWGj0M0flTq5rXSiPB0nfZaGYRvvMBGAJpehdW8KY=";
  };

  propagatedBuildInputs = [
    h5netcdf
    matplotlib
    netcdf4
    numpy
    packaging
    pandas
    scipy
    setuptools
    xarray
    xarray-einstats
  ];

  nativeCheckInputs = [
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

  pytestFlagsArray = [
    "arviz/tests/base_tests/"
  ];

  disabledTests = [
    # Tests require network access
    "test_plot_separation"
    "test_plot_trace_legend"
    "test_cov"
    # countourpy is not available at the moment
    "test_plot_kde"
    "test_plot_kde_2d"
    "test_plot_pair"
    # Array mismatch
    "test_plot_ts"
  ];

  pythonImportsCheck = [
    "arviz"
  ];

  meta = with lib; {
    description = "Library for exploratory analysis of Bayesian models";
    homepage = "https://arviz-devs.github.io/arviz/";
    changelog = "https://github.com/arviz-devs/arviz/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ omnipotententity ];
  };
}
