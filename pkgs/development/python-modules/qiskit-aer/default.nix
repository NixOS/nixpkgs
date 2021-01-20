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
}:

buildPythonPackage rec {
  pname = "qiskit-aer";
  version = "0.7.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aer";
    rev = version;
    sha256 = "07l0wavdknx0y4vy0hwgw24365sg4nb6ygl3lpa098np85qgyn4y";
  };

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
  ];

  buildInputs = [
    blas
    catch2
    fmt
    muparserx
    nlohmann_json
    spdlog
  ];

  propagatedBuildInputs = [
    cvxpy
    cython  # generates some cython files at runtime that need to be cython-ized
    numpy
    pybind11
  ];

  patches = [
    # TODO: remove in favor of qiskit-aer PR #877 patch once accepted/stable
    ./remove-conan-install.patch
  ];

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
