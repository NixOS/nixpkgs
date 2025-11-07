{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jax,
  jaxlib,
  multipledispatch,
  numpy,
  tqdm,

  # tests
  dm-haiku,
  equinox,
  flax,
  funsor,
  graphviz,
  optax,
  pyro-api,
  pytest-xdist,
  pytestCheckHook,
  scikit-learn,
  tensorflow-probability,
}:

buildPythonPackage rec {
  pname = "numpyro";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "numpyro";
    tag = version;
    hash = "sha256-3kzaINsz1Mjk97ERQsQIYIBz7CVmXtVDn0edJFMHQWs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jax
    jaxlib
    multipledispatch
    numpy
    tqdm
  ];

  nativeCheckInputs = [
    dm-haiku
    equinox
    flax
    funsor
    graphviz
    optax
    pyro-api
    pytest-xdist
    pytestCheckHook
    scikit-learn
    tensorflow-probability
  ];

  pythonImportsCheck = [ "numpyro" ];

  pytestFlags = [
    # Tests memory consumption grows significantly with the number of parallel processes (reaches ~200GB with 80 jobs)
    "--maxprocesses=8"

    # A few tests fail with:
    # UserWarning: There are not enough devices to run parallel chains: expected 2 but got 1.
    # Chains will be drawn sequentially. If you are running MCMC in CPU, consider using `numpyro.set_host_device_count(2)` at the beginning of your program.
    # You can double-check how many devices are available in your system using `jax.local_device_count()`.
    "-Wignore::UserWarning"
  ];

  disabledTests = [
    # AssertionError, assert GLOBAL["count"] == 4 (assert 5 == 4)
    "test_mcmc_parallel_chain"

    # AssertionError due to tolerance issues
    "test_bijective_transforms"
    "test_cpu"
    "test_entropy_categorical"
    "test_gaussian_model"

    # >       with pytest.warns(UserWarning, match="Hessian of log posterior"):
    # E       Failed: DID NOT WARN. No warnings of type (<class 'UserWarning'>,) were emitted.
    # E        Emitted warnings: [].
    "test_laplace_approximation_warning"

    # ValueError: compiling computation that requires 2 logical devices, but only 1 XLA devices are available (num_replicas=2)
    "test_chain"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: Not equal to tolerance rtol=0.06, atol=0
    "test_functional_map"
  ];

  disabledTestPaths = [
    # Require internet access
    "test/test_example_utils.py"
  ];

  meta = {
    description = "Library for probabilistic programming with NumPy";
    homepage = "https://num.pyro.ai/";
    changelog = "https://github.com/pyro-ppl/numpyro/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
