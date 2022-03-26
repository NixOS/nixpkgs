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
, cloudpickle
, scipy
, setuptools
, typing-extensions
# , tensorflow-probability (incompatible version)
, xarray
, zarr
, h5py
#, pymc3 (broken)
#, pyro-ppl (broken)
#, pystan (not packaged)
#, numpyro (not packaged)
}:

buildPythonPackage rec {
  pname = "arviz";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz";
    rev = "v${version}";
    sha256 = "0vindadyxhxhrhbalys6kzrda2d4qpqbqbsbwfprp8pxkldgk548";
  };

  propagatedBuildInputs = [
    # needed to install
    matplotlib
    netcdf4
    pandas
    xarray
    # needed to import
    setuptools
    # not needed to import, but used by many functions
    # and is listed as a dependency in the documentation
    numpy
    scipy
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "typing_extensions>=3.7.4.3,<4" "typing_extensions>=3.7.4.3"
  '';

  checkInputs = [
    bokeh
    emcee
    numba
    pytest
    cloudpickle
    zarr
    #tensorflow-probability (used by disabled tests)
    h5py
    #pymc3 (broken, used by disabled tests)
    #pyro-ppl (broken, used by disabled tests)
    #pystan (not packaged)
    #numpyro (not packaged, used by disabled tests)
  ];

  # check requires pymc3 and pyro-ppl, which are currently broken, and pystan
  # and numpyro, which are not yet packaged, and an incompatible (old) version
  # of tensorflow-probability. some checks also need to make
  # directories and do not have permission to do so. So we can only check part
  # of the package
  # Additionally, there are some failures with the plots test, which revolve
  # around attempting to output .mp4 files through an interface that only wants
  # to output .html files.
  # The following test have been disabled as a result: data_cmdstanpy,
  # data_numpyro, data_pyro, data_pystan, data_tfp, data_pymc3 and plots.
  checkPhase = ''
    cd arviz/tests/
    export HOME=$TMPDIR
    pytest \
      base_tests/test_data.py \
      base_tests/test_diagnostics.py \
      base_tests/test_plot_utils.py \
      base_tests/test_rcparams.py \
      base_tests/test_stats.py \
      base_tests/test_stats_numba.py \
      base_tests/test_stats_utils.py \
      base_tests/test_utils.py \
      base_tests/test_utils_numba.py \
      base_tests/test_data_zarr.py \
      external_tests/test_data_cmdstan.py \
      external_tests/test_data_emcee.py
  '';

  meta = with lib; {
    description = "ArviZ is a Python package for exploratory analysis of Bayesian models";
    homepage = "https://arviz-devs.github.io/arviz/";
    license = licenses.asl20;
    maintainers = [ maintainers.omnipotententity ];
  };
}
