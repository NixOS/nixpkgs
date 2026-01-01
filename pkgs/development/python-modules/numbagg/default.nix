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
<<<<<<< HEAD
  version = "0.9.4";
=======
  version = "0.9.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "numbagg";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "numbagg";
    repo = "numbagg";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JYgjeExpL+rbiaFPO9IHsm4Qh6GTLdTWB5dO3zIIPbs=";
=======
    hash = "sha256-MEgSxxKZaL0sPhERFa8DWF+Vkc/VuHDyyB2yfFv/uYw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
