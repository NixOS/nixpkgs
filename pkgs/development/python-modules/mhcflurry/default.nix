{ appdirs
, buildPythonPackage
, fetchFromGitHub
, keras
, lib
, mhcgnomes
, nose
, pandas
, pytestCheckHook
, pythonRelaxDepsHook
, pyyaml
, scikit-learn
, tensorflow
, tqdm
}:

buildPythonPackage rec {
  pname = "mhcflurry";
  version = "2.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openvax";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Cr7L6uo6Kc1PSeG5nK6zQSD7eeCFcUJUzhsX+waz7og=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRemoveDeps = [
    # See https://github.com/openvax/mhcflurry/issues/216.
    "np-utils"
  ];

  # keras and tensorflow are not in the official setup.py requirements but are required for the CLI utilities to run.
  propagatedBuildInputs = [
    appdirs
    keras
    mhcgnomes
    pandas
    pyyaml
    scikit-learn
    tensorflow
    tqdm
  ];

  nativeCheckInputs = [ nose pytestCheckHook ];

  disabledTests = [
    # RuntimeError: Missing MHCflurry downloadable file: /homeless-shelter/.local...
    "test_a1_mage_epitope_downloaded_models"
    "test_a1_titin_epitope_downloaded_models"
    "test_a2_hiv_epitope_downloaded_models"
    "test_basic"
    "test_caching"
    "test_class1_neural_network_a0205_training_accuracy"
    "test_commandline_sequences"
    "test_correlation"
    "test_csv"
    "test_downloaded_predictor_gives_percentile_ranks"
    "test_downloaded_predictor_invalid_peptides"
    "test_downloaded_predictor_is_savable"
    "test_downloaded_predictor_is_serializable"
    "test_downloaded_predictor_small"
    "test_downloaded_predictor"
    "test_fasta_50nm"
    "test_fasta_best"
    "test_fasta"
    "test_merge"
    "test_no_csv"
    "test_on_hpv"
    "test_run_cluster_parallelism"
    "test_run_parallel"
    "test_run_serial"
    "test_speed_allele_specific"
    "test_speed_pan_allele"

    # See https://github.com/openvax/mhcflurry/issues/217
    "test_more"
    "test_small"
  ];

  disabledTestPaths = [
    # RuntimeError: Missing MHCflurry downloadable file: /homeless-shelter/.local...
    "test/test_changing_allele_representations.py"
    "test/test_class1_affinity_predictor.py"
    "test/test_class1_pan.py"
  ];

  pythonImportsCheck = [ "mhcflurry" ];

  meta = with lib; {
    description = "Peptide-MHC I binding affinity prediction";
    homepage = "https://github.com/openvax/mhcflurry";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
