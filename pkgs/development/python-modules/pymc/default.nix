{ lib
, arviz
, buildPythonPackage
, cachetools
, cloudpickle
, fetchFromGitHub
, numpy
, pytensor
, pythonOlder
, scipy
, typing-extensions
, setuptools
, rich
}:

buildPythonPackage rec {
  pname = "pymc";
  version = "5.13.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc";
    rev = "refs/tags/v${version}";
    hash = "sha256-SSAn7nbKhXGeEvASKQITUs3+ix3j37u9JTkNiG+1tZ0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail ', "pytest-cov"' ""
  '';

  propagatedBuildInputs = [
    arviz
    cachetools
    cloudpickle
    rich
    numpy
    pytensor
    scipy
    typing-extensions
  ];

  # The test suite is computationally intensive and test failures are not
  # indicative for package usability hence tests are disabled by default.
  doCheck = false;

  pythonImportsCheck = [
    "pymc"
  ];

  meta = with lib; {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = "https://github.com/pymc-devs/pymc";
    changelog = "https://github.com/pymc-devs/pymc/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ nidabdella ferrine ];
  };
}
