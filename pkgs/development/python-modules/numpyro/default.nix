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
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "numpyro";
    tag = version;
    hash = "sha256-6i7LPdmMakGeLujhA9d7Ep9oiVcND3ni/jzUkqgEqxw=";
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
    # A few tests fail with:
    # UserWarning: There are not enough devices to run parallel chains: expected 2 but got 1.
    # Chains will be drawn sequentially. If you are running MCMC in CPU, consider using `numpyro.set_host_device_count(2)` at the beginning of your program.
    # You can double-check how many devices are available in your system using `jax.local_device_count()`.
    "-W"
    "ignore::UserWarning"
  ];

  disabledTests = [
    # AssertionError due to tolerance issues
    "test_beta_binomial_log_prob"
    "test_collapse_beta"
    "test_cpu"
    "test_gamma_poisson"
    "test_gof"
    "test_hpdi"
    "test_kl_dirichlet_dirichlet"
    "test_kl_univariate"
    "test_mean_var"

    # Tests want to download data
    "data_load"
    "test_jsb_chorales"

    # RuntimeWarning: overflow encountered in cast
    "test_zero_inflated_logits_probs_agree"

    # NameError: unbound axis name: _provenance
    "test_model_transformation"

    # ValueError: compiling computation that requires 2 logical devices, but only 1 XLA devices are available (num_replicas=2)
    "test_chain"
  ];

  disabledTestPaths = [
    # require jaxns (unpackaged)
    "test/contrib/test_nested_sampling.py"
  ];

  meta = {
    description = "Library for probabilistic programming with NumPy";
    homepage = "https://num.pyro.ai/";
    changelog = "https://github.com/pyro-ppl/numpyro/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
