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
, libredirect
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
  # This branch is missing #97597 (and its predecessor #93560), meaning only
  # "/tmp" is exempt from NIX_ENFORCE_PURITY's objections when theano is
  # imported from within a nix build environment. Therefore use libredirect
  # to convince the wrapper we are actually accessing "/tmp".
  preInstall = ''
    export HOME=$(mktemp -d)

    export NIX_REDIRECTS=/tmp=$TMPDIR
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
    export TEMP=/tmp
    export TEMPDIR=/tmp
    export TMP=/tmp
    export TMPDIR=/tmp
  '';

  meta = {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = "https://github.com/pymc-devs/pymc3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
