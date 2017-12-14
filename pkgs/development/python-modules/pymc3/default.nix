{ lib
, fetchPypi
, buildPythonPackage
, Theano
, pandas
, patsy
, joblib
, tqdm
, six
, h5py
, pytest
, nose
, nose-parameterized
, matplotlib
}:

buildPythonPackage rec {
  pname = "pymc3";
  version = "3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hpzhkpv7sbwkcva7x914yvzcf1d1a952ynbcx6mvlgv5lqghc39";
  };

  patches = [ ./0001-strip-pytest-cov.patch ];

  propagatedBuildInputs = [
    Theano
    pandas
    patsy
    joblib
    tqdm
    six
    h5py
  ];

  checkInputs = [
    pytest
    nose
    nose-parameterized
  ];

  # The test suite is computationally intensive and test failures are not
  # indicative for package usability hence tests are disabled by default.
  doCheck = false;

  # For some reason tests are run as a part of the *install* phase if enabled.
  # Theano writes compiled code to ~/.theano hence we set $HOME.
  preInstall = "export HOME=$(mktemp -d)";
  postInstall = "rm -rf $HOME";

  meta = {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = http://github.com/pymc-devs/pymc3;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
