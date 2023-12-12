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
  version = "5.10.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc";
    rev = "refs/tags/v${version}";
    hash = "sha256-+hRj39teuxlHOEQ40E2ZteU+tN73j+cHWbxzWsl1+mE=";
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
