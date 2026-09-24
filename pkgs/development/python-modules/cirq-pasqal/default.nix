{
  buildPythonPackage,
  cirq-core,
  requests,
  pytest-benchmark,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cirq-pasqal";
  pyproject = true;
  inherit (cirq-core) version src meta;

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "requests" ];

  dependencies = [
    cirq-core
    requests
  ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_pasqal" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_pasqal/_version_test.py"
  ];
})
