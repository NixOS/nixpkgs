{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

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
  version = "5.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc";
    tag = "v${version}";
    hash = "sha256-zh6FsCEviuyqapguTrUDsWKq70ef0IKRhnn2dkgQ/KA=";
  };

  patches = [
    # TODO: remove at next release
    # https://github.com/pymc-devs/pytensor/pull/1471
    (fetchpatch2 {
      name = "pytensor-2-32-compat";
      url = "https://github.com/pymc-devs/pymc/commit/59176b6adda88971e546a0cf93ca04424af5197f.patch";
      hash = "sha256-jkDwlKwxbn9DwpkxEbSXk/kbGjT/Xu8bsZHFBWYpMgA=";
    })
  ];

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
