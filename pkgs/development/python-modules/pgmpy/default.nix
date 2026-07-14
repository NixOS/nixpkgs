{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  google-generativeai,
  huggingface-hub,
  joblib,
  networkx,
  numpy,
  opt-einsum,
  pandas,
  pyparsing,
  pyro-ppl,
  scikit-base,
  scikit-learn,
  scipy,
  statsmodels,
  torch,
  tqdm,
  xgboost,

  # tests
  jsonschema,
  pytestCheckHook,
  pytest-cov-stub,
  mock,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "pgmpy";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgmpy";
    repo = "pgmpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qZoyeUaRsatWUiFoL1VaRqApjM/AFS8xqTjVBcUpYas=";
  };

  dependencies = [
    google-generativeai
    huggingface-hub
    joblib
    networkx
    numpy
    opt-einsum
    pandas
    pyparsing
    pyro-ppl
    scikit-base
    scikit-learn
    scipy
    statsmodels
    torch
    tqdm
    xgboost
  ];

  disabledTests = [
    # flaky:
    # AssertionError: -45.78899127622197 != -45.788991276221964
    "test_score"

    # self.assertTrue(np.isclose(coef, dep_coefs[i], atol=1e-4))
    # AssertionError: False is not true
    "test_pillai"

    # requires optional dependency daft
    "test_to_daft"

    # AssertionError
    "test_estimate_example_smoke_test"
    "test_gcm"

    # Network connectivity failures - tests trying to download models from HuggingFace
    # RuntimeError: Cannot send a request, as the client has been closed.
    "test_copy"
    "test_get_stats"
    "test_hash"
    "test_pc_alarm"
    "test_pc_asia"
    "test_pc_asia_expert"
    "test_temporal_pc_cancer"
    "test_temporal_pc_sachs"
    "test_orient_rule"
    "test_lgbn_schema"
    "test_load_model"
    "test_get_value"
    "test_to_dataframe"
    "test_set_value"
    "test_factor_sum_product"
    "test_query_evidence"
    "test_query_marg"
    "test_virtual_evidence"
    "test_query_raises_for_empty_variables"
    "test_query_functional_bayesian"
    "test_query_linear_gaussian"
    "test_implied_cis_cancer"
    "test_implied_cis_alarm_true_and_random"
    "test_em_init_missing_data_handling"
    "test_get_parameters"
    "test_get_parameters_ess_dict_vs_scalar"
    "test_get_parameters_initial_cpds"
    "test_get_parameters_node_specific_ess_bdeu"
    "test_get_parameters_random_init_cpds"
    "test_get_parameters_smoothing_bdeu"
    "test_get_parameters_smoothing_k2"
    "test_get_parameters_uniform_init_cpds"
    "test_comma_state_name_warning"
    "test_get_cpds"
    "test_get_parents"
    "test_get_states"
    "test_get_variables"
    "test_net_cpd"
    "test_str"
    "test_alarm_model"
    "test_whitespace_warning"
    "test_writer_cpds"
    "test_discrete_network"
    "test_input"
    "test_fisherc"
    "test_rmsea"

    # Statistical test assertion failures
    # assert False
    "test_hotelling_indep"
    "test_roys_indep"
    "test_roys_dependent"
    "test_wilks_indep"

    # Torch tensor rounding issues
    # TypeError: round() takes from 1 to 0 positional arguments but 1 were given
    # TypeError: type Tensor doesn't define __round__ method
    "test_pre_compute_reduce_maps"
    "test_pre_compute_reduce_maps_partial_evidence"
    "test_forward_sample"
    "test_rejection_sample_basic"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Failures due to numeric precision differences on Darwin
    "test_generalized_cov_approx"
    "test_roys_no_cond"
    "test_roys_dependent"
    "test_wilks_indep"
  ];

  enabledTestPaths = [
    "pgmpy/tests"
  ];

  disabledTestPaths = [
    # requires network access
    "pgmpy/tests/test_datasets"

    # Very slow
    "pgmpy/tests/test_estimators"
    "pgmpy/tests/test_models"
  ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
    pytest-cov-stub
    mock
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pgmpy" ];

  meta = {
    description = "Python Library for learning (Structure and Parameter), inference (Probabilistic and Causal), and simulations in Bayesian Networks";
    homepage = "https://github.com/pgmpy/pgmpy";
    changelog = "https://github.com/pgmpy/pgmpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
      sarahec
    ];
  };
})
