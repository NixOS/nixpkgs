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
  version = "5.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GufQIVV8OXlsUmk/FQZhrJ84P28He5Qc3pz67nLhppU=";
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
