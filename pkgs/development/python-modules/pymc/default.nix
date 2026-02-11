{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

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

buildPythonPackage (finalAttrs: {
  pname = "pymc";
  version = "5.27.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9SPRt1R36pvsGOS0UUH3Ts/3D7W46nPnLbRc2XnU0xE=";
  };

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

  nativeBuildInputs = [
    # Arviz (imported by pymc) wants to write a stamp file to the homedir at import time.
    # Without $HOME being writable, `pythonImportsCheck` fails.
    # https://github.com/arviz-devs/arviz/commit/4db612908f588d89bb5bfb6b83a08ada3d54fd02
    writableTmpDirAsHomeHook
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
