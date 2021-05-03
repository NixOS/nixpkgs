{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, python
, numpy
, qiskit-terra
, scikitlearn
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
  version = "0.6.0";

  disabled = pythonOlder "3.6";

  # Pypi's tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-ignis";
    rev = version;
    hash = "sha256-L5fwCMsN03ojiDvKIyqsGfUnwej1P7bpyHlL6mu7nh0=";
  };

  # hacky, fix https://github.com/Qiskit/qiskit-ignis/issues/532.
  # TODO: remove on qiskit-ignis v0.5.2
  postPatch = ''
    substituteInPlace qiskit/ignis/mitigation/expval/base_meas_mitigator.py --replace "plt.axes" "'plt.axes'"
  '';

  propagatedBuildInputs = [
    numpy
    qiskit-terra
    scikitlearn
    scipy
  ] ++ lib.optionals (withCvx) [ cvxpy ]
  ++ lib.optionals (withVisualization) [ matplotlib ]
  ++ lib.optionals (withJit) [ numba ];
  postInstall = "rm -rf $out/${python.sitePackages}/docs"; # this dir can create conflicts

  # Tests
  pythonImportsCheck = [ "qiskit.ignis" ];
  dontUseSetuptoolsCheck = true;
  preCheck = "export HOME=$TMPDIR";
  checkInputs = [
    pytestCheckHook
    ddt
    pyfakefs
    qiskit-aer
  ];
  disabledTests = [
    "test_tensored_meas_cal_on_circuit" # Flaky test, occasionally returns result outside bounds
    "test_qv_fitter" # execution hangs, ran for several minutes
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
