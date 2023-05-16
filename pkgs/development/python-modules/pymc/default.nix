{ lib
, arviz
, buildPythonPackage
, cachetools
, cloudpickle
, fastprogress
, fetchFromGitHub
, numpy
, pytensor
, pythonOlder
, scipy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pymc";
<<<<<<< HEAD
  version = "5.3.1";
=======
  version = "5.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-TtRIYgsPlire4li4/9Ls7Rh1SIkDGi5uCSN7huSrelA=";
=======
    hash = "sha256-ffNWSSzoRLFmYzN9sm5Z1j6WtEoFzGkCQxpBC0NlpRc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    arviz
    cachetools
    cloudpickle
    fastprogress
    numpy
    pytensor
    scipy
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace ', "pytest-cov"' ""
  '';

  # The test suite is computationally intensive and test failures are not
  # indicative for package usability hence tests are disabled by default.
  doCheck = false;

  pythonImportsCheck = [
    "pymc"
  ];

  meta = with lib; {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = "https://github.com/pymc-devs/pymc3";
    changelog = "https://github.com/pymc-devs/pymc/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ nidabdella ];
  };
}
