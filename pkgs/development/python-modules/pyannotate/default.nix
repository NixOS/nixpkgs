{
  lib,
  buildPythonPackage,
  fetchPypi,
  mypy-extensions,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pyannotate";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BO1YBLqzgVPVmB/JLYPc9qIog0U3aFYfBX53flwFdZk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    mypy-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "pyannotate_runtime"
    "pyannotate_tools"
  ];

  disabledTestPaths = [
    "pyannotate_runtime/tests/test_collect_types.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.11") [
    # Tests are using lib2to3
    "pyannotate_tools/fixes/tests/test_annotate*.py"
    "pyannotate_tools/annotations/tests/dundermain_test.py"
  ];

  meta = {
    description = "Auto-generate PEP-484 annotations";
    homepage = "https://github.com/dropbox/pyannotate";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pyannotate";
  };
}
