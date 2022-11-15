{ lib
, buildPythonPackage
, fetchFromGitHub
, bokeh
, emcee
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
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DGTGUMnkEQcwGR44WhmBpTBMcRcAtVIpM4YVnnlakE8=";
  };

  propagatedBuildInputs = [
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

  checkInputs = [
    bokeh
    cloudpickle
    emcee
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

  disabledTestPaths = [
    # Remove tests as dependency creates a circular dependency
    "arviz/tests/external_tests/test_data_pymc.py"
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
  ];

  pythonImportsCheck = [
    "arviz"
  ];

  meta = with lib; {
    description = "Library for exploratory analysis of Bayesian models";
    homepage = "https://arviz-devs.github.io/arviz/";
    license = licenses.asl20;
    maintainers = with maintainers; [ omnipotententity ];
  };
}
