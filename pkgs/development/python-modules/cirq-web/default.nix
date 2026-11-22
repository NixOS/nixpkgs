{
  buildPythonPackage,
  cirq-core,
  pytest-benchmark,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cirq-web";
  pyproject = true;
  inherit (cirq-core) version src meta;

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  build-system = [ setuptools ];

  dependencies = [ cirq-core ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_web" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_web/_version_test.py"
  ];
})
