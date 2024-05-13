{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytest-xdist
, pytestCheckHook
, setuptools-scm
, fastprogress
, jax
, jaxlib
, jaxopt
, optax
, typing-extensions
}:

buildPythonPackage rec {
  pname = "blackjax";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "blackjax-devs";
    repo = "blackjax";
    rev = "refs/tags/${version}";
    hash = "sha256-vXyxK3xALKG61YGK7fmoqQNGfOiagHFrvnU02WKZThw=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    fastprogress
    jax
    jaxlib
    jaxopt
    optax
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTestPaths = [
    "tests/test_benchmarks.py"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # Assertion errors on numerical values
    "tests/mcmc/test_integrators.py"
  ];

  disabledTests = [
    # too slow
    "test_adaptive_tempered_smc"
  ];

  pythonImportsCheck = [
    "blackjax"
  ];

  meta = with lib; {
    homepage = "https://blackjax-devs.github.io/blackjax";
    description = "Sampling library designed for ease of use, speed and modularity";
    changelog = "https://github.com/blackjax-devs/blackjax/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
