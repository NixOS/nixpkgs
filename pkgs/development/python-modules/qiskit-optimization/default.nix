{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # Python Inputs
  decorator,
  docplex,
  networkx,
  numpy,
  qiskit,
  scipy,
  # Check Inputs
  pytestCheckHook,
  ddt,
  pylatexenc,
  qiskit-aer,
}:

buildPythonPackage rec {
  pname = "qiskit-optimization";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kzEuICajlV8mgD0YLhwFJaDQVxYZo9jv3sr/r/P0VG0=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "networkx>=2.2,<2.6" "networkx"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    docplex
    decorator
    networkx
    numpy
    qiskit
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    pylatexenc
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_optimization" ];
  pytestFlags = [ "--durations=10" ];

  meta = with lib; {
    # broken because it depends on qiskit-algorithms which is not yet packaged in nixpkgs
    broken = true;
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-optimization/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
