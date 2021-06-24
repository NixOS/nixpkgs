{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, google-api-core
, matplotlib
, networkx
, numpy
, pandas
, protobuf
, requests
, scipy
, sortedcontainers
, sympy
, tqdm
, typing-extensions
  # test inputs
, freezegun
, pytestCheckHook
, pytest-asyncio
, pytest-benchmark
, ply
, pydot
, pyyaml
, pygraphviz
}:

buildPythonPackage rec {
  pname = "cirq";
  version = "0.10.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "v${version}";
    sha256 = "0xinml44n2lfl0q2lb2apmn69gsszlwim83082f66vyk0gpwd4lr";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "matplotlib~=3.0" "matplotlib" \
      --replace "networkx~=2.4" "networkx" \
      --replace "numpy~=1.16" "numpy" \
      --replace "protobuf~=3.13.0" "protobuf"
  '';

  propagatedBuildInputs = [
    google-api-core
    matplotlib
    networkx
    numpy
    pandas
    protobuf
    requests
    scipy
    sortedcontainers
    sympy
    tqdm
    typing-extensions
  ];

  # pythonImportsCheck = [ "cirq" "cirq.Circuit" ];  # cirq's importlib hook doesn't work here
  checkInputs = [
    pytestCheckHook
    freezegun
    pytest-asyncio
    pytest-benchmark
    ply
    pydot
    pyyaml
    pygraphviz
  ];

  pytestFlagsArray = [
    "--ignore=dev_tools"  # Only needed when developing new code, which is out-of-scope
    "--ignore=cirq/contrib/"  # requires external (unpackaged) python packages, so untested.
    "--benchmark-disable" # Don't need to run benchmarks when packaging.
  ];
  disabledTests = lib.optionals stdenv.isAarch64 [
    # Seem to fail due to math issues on aarch64?
    "expectation_from_wavefunction"
    "test_single_qubit_op_to_framed_phase_form_output_on_example_case"
  ] ++ [
    # slow tests, for quicker building
    "test_anneal_search_method_calls"
    "test_density_matrix_from_state_tomography_is_correct"
    "test_example_runs_qubit_characterizations"
    "test_example_runs_hello_line_perf"
    "test_example_runs_bc_mean_field_perf"
    "test_main_loop"
    "test_clifford_circuit_2"
    "test_decompose_specific_matrices"
    "test_two_qubit_randomized_benchmarking"
    "test_kak_decomposition_perf"
    "test_example_runs_simon"
    "test_decompose_random_unitary"
    "test_decompose_size_special_unitary"
    "test_api_retry_5xx_errors"
    "test_xeb_fidelity"
    "test_example_runs_phase_estimator_perf"
    "test_cross_entropy_benchmarking"
  ];

  meta = with lib; {
    description = "A framework for creating, editing, and invoking Noisy Intermediate Scale Quantum (NISQ) circuits.";
    homepage = "https://github.com/quantumlib/cirq";
    changelog = "https://github.com/quantumlib/Cirq/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
