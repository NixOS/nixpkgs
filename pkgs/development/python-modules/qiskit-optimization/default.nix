{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  setuptools,

  # runtime dependencies
  qiskit,
  scipy,
  numpy,
  docplex,
  networkx,

  # test dependencies
  pytestCheckHook,
  ddt,
  pylatexenc,
  qiskit-aer,
}:

buildPythonPackage (finalAttrs: {
  pname = "qiskit-optimization";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = "qiskit-optimization";
    tag = finalAttrs.version;
    hash = "sha256-aonL08avVZlpGQ/FCZnrsPMvu1lbhRiadzKf/oPndZk=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    qiskit
    scipy
    numpy
    docplex
    networkx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    pylatexenc
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_optimization" ];

  meta = {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-optimization/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chemonke ];
  };
})
