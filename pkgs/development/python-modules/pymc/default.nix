{
  lib,
  arviz,
  buildPythonPackage,
  cachetools,
  cloudpickle,
  fetchFromGitHub,
  numpy,
  pandas,
  pytensor,
  pythonOlder,
  rich,
  scipy,
  setuptools,
  threadpoolctl,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pymc";
  version = "5.15.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pymc";
    rev = "refs/tags/v${version}";
    hash = "sha256-TAQv3BNSYt750JSZWQibjqzhQ0zXOJDVENMharjr6gQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail ', "pytest-cov"' ""
  '';

  build-system = [ setuptools ];

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
