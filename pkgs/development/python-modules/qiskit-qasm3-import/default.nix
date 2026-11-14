{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  openqasm3,
  qiskit,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "qiskit-qasm3-import";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-qasm3-import";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+26N54aO294hjhucOtpqiCi3li1nYADKIvQycKp8wHI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    openqasm3
    qiskit
  ]
  ++ openqasm3.optional-dependencies.parser;

  pythonImportsCheck = [ "qiskit_qasm3_import" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Importer from OpenQASM 3 to Qiskit's QuantumCircuit";
    homepage = "https://github.com/Qiskit/qiskit-qasm3-import";
    changelog = "https://github.com/Qiskit/qiskit-qasm3-import/tree/${finalAttrs.src.tag}/releasenotes/notes";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
