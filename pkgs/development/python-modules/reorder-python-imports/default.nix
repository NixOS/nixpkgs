{
  lib,
  buildPythonPackage,
  classify-imports,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "reorder-python-imports";
  version = "3.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "reorder_python_imports";
    tag = "v${version}";
    hash = "sha256-oBzEPKcJO/M13+KSLZYSeMgwo28J7TZOj6H2YHkFWHU=";
  };

  build-system = [ setuptools ];

  dependencies = [ classify-imports ];

  pythonImportsCheck = [ "reorder_python_imports" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # prints an explanation about PYTHONPATH first
  # and therefore fails the assertion
  disabledTests = [ "test_success_messages_are_printed_on_stderr" ];

  meta = with lib; {
    description = "Tool for automatically reordering python imports";
    homepage = "https://github.com/asottile/reorder_python_imports";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
    mainProgram = "reorder-python-imports";
  };
}
