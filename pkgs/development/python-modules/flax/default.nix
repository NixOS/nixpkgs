{ lib
, buildPythonPackage
, fetchFromGitHub
, jaxlib
, pythonRelaxDepsHook
, setuptools-scm
, jax
, msgpack
, numpy
, optax
, pyyaml
, rich
, tensorstore
, typing-extensions
, matplotlib
, cloudpickle
, einops
, keras
, pytest-xdist
, pytestCheckHook
, tensorflow
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "flax";
    rev = "refs/tags/v${version}";
    hash = "sha256-NDah0ayQbiO1/sTU1DDf/crPq5oLTnSuosV7cFHlTM8=";
  };

  nativeBuildInputs = [
    jaxlib
    pythonRelaxDepsHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jax
    msgpack
    numpy
    optax
    pyyaml
    rich
    tensorstore
    typing-extensions
  ];

  passthru.optional-dependencies = {
    all = [ matplotlib ];
  };

  pythonImportsCheck = [
    "flax"
  ];

  nativeCheckInputs = [
    cloudpickle
    einops
    keras
    pytest-xdist
    pytestCheckHook
    tensorflow
  ];

  pytestFlagsArray = [
    "-W ignore::FutureWarning"
    "-W ignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # Docs test, needs extra deps + we're not interested in it.
    "docs/_ext/codediff_test.py"

    # The tests in `examples` are not designed to be executed from a single test
    # session and thus either have the modules that conflict with each other or
    # wrong import paths, depending on how they're invoked. Many tests also have
    # dependencies that are not packaged in `nixpkgs` (`clu`, `jgraph`,
    # `tensorflow_datasets`, `vocabulary`) so the benefits of trying to run them
    # would be limited anyway.
    "examples/*"

    # See https://github.com/google/flax/issues/3232.
    "tests/jax_utils_test.py"

    # Requires orbax which is not packaged as of 2023-07-27.
    "tests/checkpoints_test.py"
  ];

  meta = with lib; {
    description = "Neural network library for JAX";
    homepage = "https://github.com/google/flax";
    changelog = "https://github.com/google/flax/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
