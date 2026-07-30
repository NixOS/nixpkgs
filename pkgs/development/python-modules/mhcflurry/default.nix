{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  appdirs,
  mhcgnomes,
  numpy,
  pandas,
  pyyaml,
  scikit-learn,
  torch,
  tqdm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mhcflurry";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openvax";
    repo = "mhcflurry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vtlj6aK4o7rjhWeTaso/RBZWZFdoZy54AlTrYWUoGfE=";
  };

  build-system = [
    setuptools
  ];

  # keras and tensorflow are not in the official setup.py requirements but are required for the CLI utilities to run.
  dependencies = [
    appdirs
    mhcgnomes
    numpy
    pandas
    pyyaml
    scikit-learn
    torch
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: Missing MHCflurry downloadable file: /homeless-shelter/.local...
    "test_a1_mage_epitope_downloaded_models"
    "test_a1_titin_epitope_downloaded_models"
    "test_a2_hiv_epitope_downloaded_models"
    "test_allele_specific_affinity_predictions"
    "test_basic"
    "test_caching"
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
    "test_fasta_best"
    "test_merge"
    "test_no_csv"
    "test_on_hpv"
    "test_pan_allele_affinity_predictions"
    "test_presentation_predictions"
    "test_run_cluster_parallelism"
    "test_run_parallel"
    "test_run_serial"
    "test_selected_peptides_mhcflurry_matches_csv"
    "test_selected_peptides_netmhcpan_affinity_close"
    "test_speed_allele_specific"
    "test_speed_pan_allele"
  ];

  disabledTestPaths = [
    # RuntimeError: Missing MHCflurry downloadable file: /homeless-shelter/.local...
    "test/test_changing_allele_representations.py"
    "test/test_class1_affinity_predictor.py"
    "test/test_class1_pan.py"
  ];

  pythonImportsCheck = [ "mhcflurry" ];

  meta = {
    description = "Peptide-MHC I binding affinity prediction";
    homepage = "https://github.com/openvax/mhcflurry";
    changelog = "https://github.com/openvax/mhcflurry/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
