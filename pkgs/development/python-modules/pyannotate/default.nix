{
  lib,
  buildPythonPackage,
  fetchPypi,
  mypy-extensions,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pyannotate";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  disabledTestPaths =
    [
      "pyannotate_runtime/tests/test_collect_types.py"
    ]
    ++ lib.optionals (pythonAtLeast "3.11") [
      # Tests are using lib2to3
      "pyannotate_tools/fixes/tests/test_annotate*.py"
    ];

  meta = with lib; {
    description = "Auto-generate PEP-484 annotations";
    homepage = "https://github.com/dropbox/pyannotate";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "pyannotate";
  };
}
