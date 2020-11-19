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
  version = "3.9.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abe046f5a5d0e5baee80b7c4bc0a4c218f61b517b62d77be4f89cf4784c27d78";
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
