{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
  # Python Inputs
, decorator
, docplex
, networkx
, numpy
, qiskit-terra
, scipy
  # Check Inputs
, pytestCheckHook
, ddt
, pylatexenc
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-optimization";
  version = "0.4.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-7MksgbCID4x1qW06BCBzcbiS/eNHjZiDKIvKYTPx6cc=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "networkx>=2.2,<2.6" "networkx"
  '';

  propagatedBuildInputs = [
    docplex
    decorator
    networkx
    numpy
    qiskit-terra
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    pylatexenc
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_optimization" ];
  pytestFlagsArray = [ "--durations=10" ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-optimization/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
