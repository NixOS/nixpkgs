{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, Theano
, pandas
, patsy
, joblib
, tqdm
, six
, h5py
, pytest
, nose
, parameterized
}:

buildPythonPackage rec {
  pname = "pymc3";
  version = "3.5";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6088e683c6d730bb21350a0f54ee083fa5a28e4d5ef52d57878141c9c20f21ee";
  };

  # No need for coverage stats in Nix builds
  postPatch = ''
    substituteInPlace setup.py --replace ", 'pytest-cov'" ""
  '';

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
    parameterized
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
    homepage = https://github.com/pymc-devs/pymc3;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
