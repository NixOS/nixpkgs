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
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-N4mf5ins0x+yUAIq+yyjSnUrHcaEhH/Jpid/QMhIjE0=";
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
