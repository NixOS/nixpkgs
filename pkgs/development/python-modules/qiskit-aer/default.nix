{ stdenv
, lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
  # C Inputs
, blas
, catch2
, cmake
, cython
, fmt
, muparserx
, ninja
, nlohmann_json
, spdlog
  # Python Inputs
, cvxpy
, numpy
, pybind11
, scikit-build
  # Check Inputs
, pytestCheckHook
, ddt
, fixtures
, pytest-timeout
, qiskit-terra
, setuptools
, testtools
}:

buildPythonPackage rec {
  pname = "qiskit-aer";
  version = "0.13.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aer";
    rev = "refs/tags/${version}";
    hash = "sha256-GxQgqCUDwalgM9m+XeRiZCRL93KrCSUPoLvDgHJJGCQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'cmake!=3.17,!=3.17.0'," "" \
      --replace "'pybind11', min_version='2.6'" "'pybind11'" \
      --replace "pybind11>=2.6" "pybind11" \
      --replace "scikit-build>=0.11.0" "scikit-build" \
      --replace "min_version='0.11.0'" ""
  '';

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
  ];

  buildInputs = [
    blas
    catch2
    nlohmann_json
    fmt
    muparserx
    spdlog
  ];

  propagatedBuildInputs = [
    cvxpy
    cython  # generates some cython files at runtime that need to be cython-ized
    numpy
    pybind11
  ];

  preBuild = ''
    export DISABLE_CONAN=1
  '';

  dontUseCmakeConfigure = true;

  # *** Testing ***
  pythonImportsCheck = [
    "qiskit.providers.aer"
    "qiskit.providers.aer.backends.qasm_simulator"
    "qiskit.providers.aer.backends.controller_wrappers" # Checks C++ files built correctly. Only exists if built & moved to output
  ];

  disabledTests = [
    # these tests don't work with cvxpy >= 1.1.15
    "test_clifford"
    "test_approx_random"
    "test_snapshot" # TODO: these ~30 tests fail on setup due to pytest fixture issues?
    "test_initialize_2" # TODO: simulations appear incorrect, off by >10%.
    "test_pauli_error_2q_gate_from_string_1qonly"

    # these fail for some builds. Haven't been able to reproduce error locally.
    "test_kraus_gate_noise"
    "test_backend_method_clifford_circuits_and_kraus_noise"
    "test_backend_method_nonclifford_circuit_and_kraus_noise"
    "test_kraus_noise_fusion"

    # Slow tests
    "test_paulis_1_and_2_qubits"
    "test_3d_oscillator"
    "_057"
    "_136"
    "_137"
    "_139"
    "_138"
    "_140"
    "_141"
    "_143"
    "_144"
    "test_sparse_output_probabilities"
    "test_reset_2_qubit"

    # Fails with 0.10.4
    "test_extended_stabilizer_sparse_output_probs"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    fixtures
    pytest-timeout
    qiskit-terra
    testtools
  ];

  pytestFlagsArray = [
    "--timeout=30"
    "--durations=10"
  ];

  preCheck = ''
    # Tests include a compiled "circuit" which is auto-built in $HOME
    export HOME=$(mktemp -d)
    # move tests b/c by default try to find (missing) cython-ized code in /build/source dir
    cp -r $TMP/$sourceRoot/test $HOME

    # Add qiskit-aer compiled files to cython include search
    pushd $HOME
  '';

  postCheck = "popd";

  meta = with lib; {
    broken = true;
    description = "High performance simulators for Qiskit";
    homepage = "https://qiskit.org/aer";
    downloadPage = "https://github.com/QISKit/qiskit-aer/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
