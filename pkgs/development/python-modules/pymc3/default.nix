{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, theano-pymc
, pandas
, patsy
, joblib
, cachetools
, tqdm
, six
, h5py
, arviz
, packaging
, pytest
, nose
, parameterized
, fastprogress
, typing-extensions
, dill
, semver
}:

buildPythonPackage rec {
  pname = "pymc3";
  version = "3.11.4";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b88d1e6c85f7fb8a9b99d6f136ac860672170370ec4146338fdd160c3b3fd3f";
  };

  # No need for coverage stats in Nix builds
  postPatch = ''
    substituteInPlace setup.py --replace ", 'pytest-cov'" ""
  '';

  propagatedBuildInputs = [
    pandas
    patsy
    joblib
    tqdm
    six
    h5py
    arviz
    packaging
    fastprogress
    typing-extensions
    dill
    theano-pymc
    cachetools
    semver
  ];

  # The test suite is computationally intensive and test failures are not
  # indicative for package usability hence tests are disabled by default.
  doCheck = false;
  pythonImportsCheck = [ "pymc3" ];

  # For some reason tests are run as a part of the *install* phase if enabled.
  # Theano writes compiled code to ~/.theano hence we set $HOME.
  preInstall = "export HOME=$(mktemp -d)";
  postInstall = "rm -rf $HOME";

  meta = {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = "https://github.com/pymc-devs/pymc3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nidabdella ];
  };
}
