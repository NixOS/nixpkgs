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
  matplotlib,
  numpy,
  pandas,
  pytensor,
  rich,
  scipy,
  threadpoolctl,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymc";
  version = "6.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-laLj0Dts4E/7cuhQt/1mekfi/P1L7TiOcypiADs0JAc=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  pythonRelaxDeps = [
    "cachetools"
  ];
  dependencies = [
    arviz
    cachetools
    cloudpickle
    # `matplotlib` is an undeclared runtime dependency: the default (`progressbar = True`) sampling
    # path imports it in `pymc/progress_bar/rich_progress.py`.
    matplotlib
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
    changelog = "https://github.com/pymc-devs/pymc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nidabdella
    ];
  };
})
