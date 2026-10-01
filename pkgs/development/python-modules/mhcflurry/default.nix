{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ahocorasick-rs,
  appdirs,
  matplotlib,
  mhcgnomes,
  numpy,
  pandas,
  pyyaml,
  scikit-learn,
  threadpoolctl,
  torch,
  tqdm,

  # tests
  addBinToPathHook,
  gitMinimal,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mhcflurry";
  version = "2.3.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openvax";
    repo = "mhcflurry";
    tag = finalAttrs.version;
    hash = "sha256-W9tNI1MC1SJ5RUT/Ahc/NOycU7p04+MeKazt+G8e3qg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ahocorasick-rs
    appdirs
    matplotlib
    mhcgnomes
    numpy
    pandas
    pyyaml
    scikit-learn
    threadpoolctl
    torch
    tqdm
  ];

  nativeCheckInputs = [
    addBinToPathHook # Some tests invoke the `mhcflurry` executable
    gitMinimal
    pytestCheckHook
    versionCheckHook
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # The default `macosx` matplotlib backend aborts (SIGABRT) in the darwin sandbox
    MPLBACKEND = "Agg";
  };

  disabledTests = [
    # RuntimeError: Missing MHCflurry downloadable file: /homeless-shelter/.local...
    "test_a1_mage_epitope_downloaded_models"
    "test_a1_titin_epitope_downloaded_models"
    "test_a2_hiv_epitope_downloaded_models"
    "test_allele_specific_affinity_predictions"
    "test_basic"
    "test_caching"
    "test_canonicalize_allele_series_against_real_allele_sequences"
    "test_canonicalize_allele_series_resolves_a_real_retired_alias"
    "test_class1_neural_network_a0205_training_accuracy"
    "test_commandline_sequences"
    "test_correlation"
    "test_csv"
    "test_downloaded_predictor"
    "test_downloaded_predictor_gives_percentile_ranks"
    "test_downloaded_predictor_invalid_peptides"
    "test_downloaded_predictor_is_savable"
    "test_downloaded_predictor_is_serializable"
    "test_downloaded_predictor_small"
    "test_fasta"
    "test_fasta_50nm"
    "test_merge"
    "test_no_csv"
    "test_on_hpv"
    "test_pan_allele_affinity_predictions"
    "test_predictor_canonicalize_matches_resolver"
    "test_presentation_predictions"
    "test_run_cluster_parallelism"
    "test_run_parallel"
    "test_run_serial"
    "test_selected_peptides_mhcflurry_matches_csv"
    "test_selected_peptides_netmhcpan_affinity_close"
    "test_speed_allele_specific"
    "test_speed_pan_allele"
    "test_stdout_contains_only_parseable_csv"
    "test_training_is_reproducible_from_seed"
    "test_training_retains_noncanonical_allele_names"

    # Subprocess overrides PYTHONPATH, hiding dependencies
    # ModuleNotFoundError: No module named 'tqdm'
    "test_catalogue_discovery_with_unknown_environment_release"
    "test_discovery_does_not_import_numerical_stack"

    # FileNotFoundError: [Errno 2] No such file or directory: '/build/pytest-.../fake_mhctools.py'
    # (`#!/usr/bin/env python3` shebang)
    "test_eval_paper_figures_external_predictors_adds_columns"

    # Release tooling: requires the source tree to be a git checkout
    "test_brev_postprocess_archive_includes_release_holdout"
    "test_deploy_creates_draft_noninteractively_with_release_notes"
    "test_deploy_packages_only_requested_processing_variants"
    "test_deploy_rejects_artifacts_from_a_different_commit"
    "test_release_workflow_brev_prepare_uses_remote_postprocess"
    "test_release_workflow_ssh_preflight_is_dry_run_visible"
    "test_release_workflow_validates_selected_runplz_interpreter"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # assert 2 == 1 (torch thread count in forked worker)
    "test_forked_worker_applies_runtime_cpu_thread_budget"
  ];

  disabledTestPaths = [
    # RuntimeError: Missing MHCflurry downloadable file: /homeless-shelter/.local...
    "test/test_changing_allele_representations.py"
    "test/test_class1_affinity_predictor.py"
    "test/test_class1_pan.py"
    "test/test_doctest.py"
    "test/test_predict_scan_command.py"
    "test/test_torch_baseline_regression.py"

    # Release tooling: requires the source tree to be a git checkout
    "test/test_deploy_percent_ranks.py"
    "test/test_release_provenance.py"
  ];

  pythonImportsCheck = [ "mhcflurry" ];

  meta = {
    description = "Peptide-MHC I binding affinity prediction";
    homepage = "https://github.com/openvax/mhcflurry";
    mainProgram = "mhcflurry";
    changelog = "https://github.com/openvax/mhcflurry/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
