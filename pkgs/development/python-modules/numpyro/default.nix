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
  # Our current version of tensorflow (2.13.0) is too old and doesn't support python>=3.12
  # We remove optional test dependencies that require tensorflow and skip the corresponding tests to
  # avoid introducing a useless incompatibility with python 3.12:
  # dm-haiku,
  # flax,
  # tensorflow-probability,
  funsor,
  graphviz,
  optax,
  pyro-api,
  pytestCheckHook,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "numpyro";
  version = "0.15.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "numpyro";
    rev = "refs/tags/${version}";
    hash = "sha256-g+ep221hhLbCjQasKpiEAXkygI5A3Hglqo1tV8lv5eg=";
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
    # dm-haiku
    # flax
    funsor
    graphviz
    optax
    pyro-api
    pytestCheckHook
    scikit-learn
    # tensorflow-probability
  ];

  pythonImportsCheck = [ "numpyro" ];

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

    # require dm-haiku
    "test_flax_state_dropout_smoke"
    "test_flax_module"
    "test_random_module_mcmc"

    # require flax
    "test_haiku_state_dropout_smoke"
    "test_haiku_module"
    "test_random_module_mcmc"

    # require tensorflow-probability
    "test_modified_bessel_first_kind_vect"
    "test_diag_spectral_density_periodic"
    "test_kernel_approx_periodic"
    "test_modified_bessel_first_kind_one_dim"
    "test_modified_bessel_first_kind_vect"
    "test_periodic_gp_one_dim_model"
    "test_no_tracer_leak_at_lazy_property_sample"

    # flaky on darwin
    # TODO: uncomment at next release (0.15.4) as it has been fixed:
    # https://github.com/pyro-ppl/numpyro/pull/1863
    "test_change_point_x64"
  ];

  disabledTestPaths = [
    # require jaxns (unpackaged)
    "test/contrib/test_nested_sampling.py"

    # requires tensorflow-probability
    "test/contrib/test_tfp.py"
    "test/test_distributions.py"
  ];

  meta = {
    description = "Library for probabilistic programming with NumPy";
    homepage = "https://num.pyro.ai/";
    changelog = "https://github.com/pyro-ppl/numpyro/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
