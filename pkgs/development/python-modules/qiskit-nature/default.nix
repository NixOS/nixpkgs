{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
  # Python Inputs
, h5py
, numpy
, psutil
, qiskit-terra
, rustworkx
, scikit-learn
, scipy
, withPyscf ? false
, pyscf
  # Check Inputs
, pytestCheckHook
, ddt
, pylatexenc
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-nature";
  version = "0.7.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-RspjHEFYdu1k6azmifbpd57tH+SxPeepw5EQzWP/Yc8=";
  };

  propagatedBuildInputs = [
    h5py
    numpy
    psutil
    qiskit-terra
    rustworkx
    scikit-learn
    scipy
  ] ++ lib.optional withPyscf pyscf;

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    pylatexenc
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_nature" ];

  pytestFlagsArray = [
    "--durations=10"
  ];

  disabledTests = [
    "test_two_qubit_reduction"  # failure cause unclear
  ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-nature/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode  # drivers/gaussiand/gauopen/*.so
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
