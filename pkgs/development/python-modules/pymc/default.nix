{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  versioneer,

  # dependencies
  arviz,
  cachetools,
  cloudpickle,
  numpy,
  pandas,
  pytensor,
  rich,
  scipy,
  threadpoolctl,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pymc";
  version = "5.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc";
    tag = "v${version}";
    hash = "sha256-AHQ1x5Adhn0wQOzh9H+m0D7JpAB2XfCU0ovgkmS+Hzc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail ', "pytest-cov"' ""
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    arviz
    cachetools
    cloudpickle
    numpy
    pandas
    pytensor
    rich
    scipy
    threadpoolctl
    typing-extensions
  ];

  # The test suite is computationally intensive and test failures are not
  # indicative for package usability hence tests are disabled by default.
  doCheck = false;

  pythonImportsCheck = [ "pymc" ];

  meta = {
    description = "Bayesian estimation, particularly using Markov chain Monte Carlo (MCMC)";
    homepage = "https://github.com/pymc-devs/pymc";
    changelog = "https://github.com/pymc-devs/pymc/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nidabdella
      ferrine
    ];
  };
}
