{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # Python Inputs
  fastdtw,
  numpy,
  psutil,
  qiskit-terra,
  scikit-learn,
  sparse,
  torch,
  # Check Inputs
  pytestCheckHook,
  ddt,
  pytest-timeout,
  qiskit-aer,
}:

buildPythonPackage rec {
  pname = "qiskit-machine-learning";
  version = "0.8.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = pname;
    tag = version;
    hash = "sha256-XnLCejK6m8p/OC5gKCoP1UXVblISChu3lKF8BnrnRbk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    fastdtw
    numpy
    psutil
    torch
    qiskit-terra
    scikit-learn
    sparse
  ];

  doCheck = false; # TODO: enable. Tests fail on unstable due to some multithreading issue?
  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
    ddt
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_machine_learning" ];

  pytestFlags = [
    "--durations=10"
    "--showlocals"
    "-vv"
  ];
  disabledTestPaths = [
    "test/connectors/test_torch_connector.py" # TODO: fix, get multithreading errors with python3.9, segfaults
  ];
  disabledTests = [
    # Slow tests >10 s
    "test_readme_sample"
    "test_vqr_8"
    "test_vqr_7"
    "test_qgan_training_cg"
    "test_vqc_4"
    "test_classifier_with_circuit_qnn_and_cross_entropy_4"
    "test_vqr_4"
    "test_regressor_with_opflow_qnn_4"
    "test_qgan_save_model"
    "test_qgan_training_analytic_gradients"
    "test_qgan_training_run_algo_numpy"
    "test_ad_hoc_data"
    "test_qgan_training"
  ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-optimization/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
