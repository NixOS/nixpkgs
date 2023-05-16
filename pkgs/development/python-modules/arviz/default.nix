{ lib
, buildPythonPackage
, fetchFromGitHub
, emcee
<<<<<<< HEAD
, h5netcdf
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.15.1";
=======
  version = "0.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-jjA+yltvpPZldIxXXqu1bXCLqpiU5/NBYTPlI9ImGVs=";
  };

  propagatedBuildInputs = [
    h5netcdf
=======
    hash = "sha256-LcdITCT9Bvycfj/taXhzkjn4IfZrxWX9MYXD6+MifOs=";
  };

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
=======
  disabledTestPaths = [
    # Remove tests as dependency creates a circular dependency
    "arviz/tests/external_tests/test_data_pymc.py"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTests = [
    # Tests require network access
    "test_plot_separation"
    "test_plot_trace_legend"
    "test_cov"
    # countourpy is not available at the moment
    "test_plot_kde"
    "test_plot_kde_2d"
    "test_plot_pair"
<<<<<<< HEAD
    # Array mismatch
    "test_plot_ts"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "arviz"
  ];

  meta = with lib; {
    description = "Library for exploratory analysis of Bayesian models";
    homepage = "https://arviz-devs.github.io/arviz/";
<<<<<<< HEAD
    changelog = "https://github.com/arviz-devs/arviz/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ omnipotententity ];
  };
}
