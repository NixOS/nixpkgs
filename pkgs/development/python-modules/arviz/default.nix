{ lib
, buildPythonPackage
, fetchFromGitHub
, emcee
, matplotlib
, netcdf4
, numba
, numpy
, pandas
, pytest
, scipy
, setuptools
, tensorflow-probability
, xarray
#, h5py (used by disabled tests)
#, pymc3 (broken)
#, pyro-ppl (broken)
#, pystan (not packaged)
#, numpyro (not packaged)
}:

buildPythonPackage rec {
  pname = "arviz";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz";
    rev = version;
    sha256 = "0p600cakix24wz2ridnzy6sp3l1p2kr5s60qc7s82wpv7fw0i9ry";
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

  checkInputs = [
    emcee
    numba
    pytest
    tensorflow-probability
    #h5py (used by disabled tests)
    #pymc3 (broken)
    #pyro-ppl (broken)
    #pystan (not packaged)
    #numpyro (not packaged)
  ];

  # check requires pymc3 and pyro-ppl, which are currently broken, and pystan
  # and numpyro, which are not yet packaged, some checks also need to make
  # directories and do not have permission to do so. So we can only check part
  # of the package
  # Additionally, there are some failures with the plots test, which revolve
  # around attempting to output .mp4 files through an interface that only wants
  # to output .html files.
  # The following test have been disabled as a result: data_cmdstanpy,
  # data_numpyro, data_pyro, data_pystan, and plots.
  checkPhase = ''
    cd arviz/tests/
    HOME=$TMPDIR pytest test_{data_cmdstan,data_emcee,data,data_tfp,\
    diagnostics,plot_utils,rcparams,stats,stats_utils,utils}.py
  '';

  meta = with lib; {
    description = "ArviZ is a Python package for exploratory analysis of Bayesian models";
    homepage = "https://arviz-devs.github.io/arviz/";
    license = licenses.asl20;
    maintainers = [ maintainers.omnipotententity ];
  };
}
