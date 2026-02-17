{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  numba,
  numpy,

  # tests
  pytestCheckHook,
  bottleneck,
  hypothesis,
  pandas,
  pytest-benchmark,
  tabulate,
}:

buildPythonPackage rec {
  version = "0.9.4";
  pname = "numbagg";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "numbagg";
    repo = "numbagg";
    tag = "v${version}";
    hash = "sha256-JYgjeExpL+rbiaFPO9IHsm4Qh6GTLdTWB5dO3zIIPbs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    numba
  ];

  pythonImportsCheck = [ "numbagg" ];

  nativeCheckInputs = [
    pytestCheckHook

    pandas
    bottleneck
    hypothesis
    tabulate
    pytest-benchmark
  ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = {
    description = "Fast N-dimensional aggregation functions with Numba";
    homepage = "https://github.com/numbagg/numbagg";
    changelog = "https://github.com/numbagg/numbagg/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
