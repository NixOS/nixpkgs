{
  buildPythonPackage,
  cirq-core,
  setuptools,
  pyquil,
  qcs-sdk-python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cirq-rigetti";
  pyproject = true;
  inherit (cirq-core) version src;

  sourceRoot = "${src.name}/${pname}";

  pythonRelaxDeps = [
    "pyquil"
    "qcs-sdk-python"
  ];

  postPatch = ''
    # Remove outdated test
    rm cirq_rigetti/service_test.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    cirq-core
    pyquil
    qcs-sdk-python
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_rigetti/_version_test.py"
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_rigetti" ];

  meta = {
    inherit (cirq-core.meta) changelog license maintainers;
    description = "Cirq package to simulate and connect to Rigetti quantum computers and Quil QVM";
    homepage = "https://github.com/quantumlib/Cirq/tree/main/cirq-rigetti";
  };
}
