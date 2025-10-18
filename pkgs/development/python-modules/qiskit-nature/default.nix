{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # Python Inputs
  h5py,
  numpy,
  psutil,
  qiskit,
  rustworkx,
  scikit-learn,
  scipy,
  withPyscf ? false,
  pyscf,
  # Check Inputs
  pytestCheckHook,
  ddt,
  pylatexenc,
  qiskit-aer,
}:

buildPythonPackage rec {
  pname = "qiskit-nature";
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-SVzg3McB885RMyAp90Kr6/iVKw3Su9ucTob2jBckBo0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    h5py
    numpy
    psutil
    qiskit
    rustworkx
    scikit-learn
    scipy
  ]
  ++ lib.optional withPyscf pyscf;

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    pylatexenc
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_nature" ];

  pytestFlags = [ "--durations=10" ];

  disabledTests = [
    "test_two_qubit_reduction" # failure cause unclear
  ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-nature/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode # drivers/gaussiand/gauopen/*.so
    ];
    license = licenses.asl20;
    maintainers = [ ];
  };
}
