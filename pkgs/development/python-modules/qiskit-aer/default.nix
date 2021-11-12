{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
  # C Inputs
, blas
, catch2
, cmake
, cython
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
}:

buildPythonPackage rec {
  pname = "qiskit-aer";
  version = "0.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aer";
    rev = version;
    hash = "sha256-7NWM7qpMQ3vA6p0dhEPnkBjsPMdhceYTYcAD4tsClf0=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/Qiskit/qiskit-aer/pull/1250
      name = "qiskit-aer-pr-1250-native-cmake_dl_libs.patch";
      url = "https://github.com/Qiskit/qiskit-aer/commit/2bf04ade3e5411776817706cf82cc67a3b3866f6.patch";
      sha256 = "0ldwzxxfgaad7ifpci03zfdaj0kqj0p3h94qgshrd2953mf27p6z";
    })
  ];
  # Remove need for cmake python package
  # pybind11 shouldn't be an install requirement, just build requirement.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'cmake!=3.17,!=3.17.0'," "" \
      --replace "'pybind11>=2.6'" ""
  '';

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
    pybind11
  ];

  buildInputs = [
    blas
    catch2
    muparserx
    nlohmann_json
    spdlog
  ];

  propagatedBuildInputs = [
    cvxpy
    cython  # generates some cython files at runtime that need to be cython-ized
    numpy
  ];

  # Disable using conan for build
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
  # Slow tests
  disabledTests = [
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
  ];
  checkInputs = [
    pytestCheckHook
    ddt
    fixtures
    pytest-timeout
    qiskit-terra
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
    description = "High performance simulators for Qiskit";
    homepage = "https://qiskit.org/aer";
    downloadPage = "https://github.com/QISKit/qiskit-aer/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
