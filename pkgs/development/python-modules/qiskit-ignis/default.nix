{ lib
, stdenv
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, numpy
, qiskit-terra
, scikit-learn
, scipy
  # Optional package inputs
, withVisualization ? false
, matplotlib
, withCvx ? false
, cvxpy
, withJit ? false
, numba
  # Check Inputs
, pytestCheckHook
, ddt
, pyfakefs
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-ignis";
  version = "0.7.1";

  disabled = pythonOlder "3.6";

  # Pypi's tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-ignis";
    rev = "refs/tags/${version}";
    hash = "sha256-WyLNtZhtuGzqCJdOBvtBjZZiGFQihpeSjJQtP7lI248=";
  };

  propagatedBuildInputs = [
    numpy
    qiskit-terra
    scikit-learn
    scipy
  ] ++ lib.optionals (withCvx) [ cvxpy ]
  ++ lib.optionals (withVisualization) [ matplotlib ]
  ++ lib.optionals (withJit) [ numba ];

  # Tests
  pythonImportsCheck = [ "qiskit.ignis" ];
  dontUseSetuptoolsCheck = true;
  preCheck = ''
    export HOME=$TMPDIR
  '';
  nativeCheckInputs = [
    pytestCheckHook
    ddt
    pyfakefs
    qiskit-aer
  ];
  disabledTests = [
    "test_tensored_meas_cal_on_circuit" # Flaky test, occasionally returns result outside bounds
  ] ++ lib.optionals stdenv.isAarch64 [
    "test_fitters" # Fails check that arrays are close. Might be due to aarch64 math issues.
  ];

  meta = with lib; {
    description = "Qiskit tools for quantum hardware verification, noise characterization, and error correction";
    homepage = "https://qiskit.org/ignis";
    downloadPage = "https://github.com/QISKit/qiskit-ignis/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
