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
, arviz
, packaging
, pytest
, nose
, parameterized
, fastprogress
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pymc3";
  version = "3.11.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3b93c8923ae8c8107c5adfd22f7c37fa0849a00a9723e0e0a0ca6afb582d6c3";
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
    arviz
    packaging
    fastprogress
    typing-extensions
  ];

  checkInputs = [
    pytest
    nose
    parameterized
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
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
