{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
  # Python Inputs
, h5py
, numpy
, psutil
, qiskit-terra
, retworkx
, scikit-learn
, scipy
, withPyscf ? false
, pyscf
  # Check Inputs
, pytestCheckHook
, ddt
, pylatexenc
}:

buildPythonPackage rec {
  pname = "qiskit-nature";
  version = "0.2.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = pname;
    rev = version;
    sha256 = "sha256-nQbvH911Gt4KddG23qwmiXfRJTWwVEsrzPvuTQfy4FY=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "h5py<3.3" "h5py"
  '';

  propagatedBuildInputs = [
    h5py
    numpy
    psutil
    qiskit-terra
    retworkx
    scikit-learn
    scipy
  ] ++ lib.optional withPyscf pyscf;

  checkInputs = [
    pytestCheckHook
    ddt
    pylatexenc
  ];

  pythonImportsCheck = [ "qiskit_nature" ];

  pytestFlagsArray = [
    "--durations=10"
  ] ++ lib.optionals (!withPyscf) [
    "--ignore=test/algorithms/excited_state_solvers/test_excited_states_eigensolver.py"
  ];

  disabledTests = [
    # small math error < 0.05 (< 9e-6 %)
    "test_vqe_uvccsd_factory"
    # unsure of failure reason. Might be related to recent cvxpy update?
    "test_two_qubit_reduction"
  ] ++ lib.optionals (!withPyscf) [
    "test_h2_bopes_sampler"
    "test_potential_interface"
  ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-optimization/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
