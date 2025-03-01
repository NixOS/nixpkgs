{
  lib,
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
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "numpyro";
    tag = version;
    hash = "sha256-S5A5wBb2ZMxpLvP/EYahdg2BqgzKGvnzvZOII76O/+w=";
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

  pytestFlagsArray = [
    # Tests memory consumption grows significantly with the number of parallel processes (reaches ~200GB with 80 jobs)
    "--maxprocesses=8"

    # A few tests fail with:
    # UserWarning: There are not enough devices to run parallel chains: expected 2 but got 1.
    # Chains will be drawn sequentially. If you are running MCMC in CPU, consider using `numpyro.set_host_device_count(2)` at the beginning of your program.
    # You can double-check how many devices are available in your system using `jax.local_device_count()`.
    "-W"
    "ignore::UserWarning"
  ];

  disabledTests = [
    # AssertionError due to tolerance issues
    "test_bijective_transforms"
    "test_cpu"
    "test_entropy_categorical"
    "test_gaussian_model"

    # >       with pytest.warns(UserWarning, match="Hessian of log posterior"):
    # E       Failed: DID NOT WARN. No warnings of type (<class 'UserWarning'>,) were emitted.
    # E        Emitted warnings: [].
    "test_laplace_approximation_warning"

    # Tests want to download data
    "data_load"
    "test_jsb_chorales"

    # ValueError: compiling computation that requires 2 logical devices, but only 1 XLA devices are available (num_replicas=2)
    "test_chain"

    # test_biject_to[CorrMatrix()-(15,)] - assert Array(False, dtype=bool)
    "test_biject_to"
  ];

  meta = {
    description = "Library for probabilistic programming with NumPy";
    homepage = "https://num.pyro.ai/";
    changelog = "https://github.com/pyro-ppl/numpyro/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
