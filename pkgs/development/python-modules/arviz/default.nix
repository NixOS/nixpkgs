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
, setuptools
, cloudpickle
, pytestCheckHook
, scipy
, packaging
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
, bokeh
}:

buildPythonPackage rec {
  pname = "arviz";
  version = "0.17.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz";
    rev = "refs/tags/v${version}";
    hash = "sha256-DqVwbiNJHdRxK3Ppfa6sqPJzDqMaj1mtlAJHFq09u2Y=";
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
    bokeh
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    "arviz/tests/base_tests/"
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
    # Array mismatch
    "test_plot_ts"
    # The following two tests fail in a common venv-based setup.
    # An issue has been opened upstream: https://github.com/arviz-devs/arviz/issues/2282
    "test_plot_ppc_discrete"
    "test_plot_ppc_discrete_save_animation"
    # Assertion error
    "test_data_zarr"
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
