{ lib
, aeppl
, aesara
, arviz
, buildPythonPackage
, cachetools
, cloudpickle
, fastprogress
, fetchFromGitHub
, numpy
, pythonOlder
, pythonRelaxDepsHook
, scipy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pymc";
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc";
    rev = "refs/tags/v${version}";
    hash = "sha256-uWvzWbZyRRE8L9X9+azmN+1JYahwwNSYCk2fQ/C8Yi0=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aeppl
    aesara
    arviz
    cachetools
    cloudpickle
    fastprogress
    numpy
    scipy
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace ', "pytest-cov"' ""
  '';

  pythonRelaxDeps = [
    "aesara"
    "aeppl"
  ];

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
