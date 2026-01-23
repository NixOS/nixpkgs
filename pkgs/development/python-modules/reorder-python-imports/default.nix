{
  lib,
  buildPythonPackage,
  classify-imports,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "reorder-python-imports";
  version = "3.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "reorder_python_imports";
    tag = "v${version}";
    hash = "sha256-fncrrmksYS+8pz9qVucf4ktxxVvnrKEzIeM5kPrh0PQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ classify-imports ];

  pythonImportsCheck = [ "reorder_python_imports" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # prints an explanation about PYTHONPATH first
  # and therefore fails the assertion
  disabledTests = [ "test_success_messages_are_printed_on_stderr" ];

  meta = {
    description = "Tool for automatically reordering python imports";
    homepage = "https://github.com/asottile/reorder_python_imports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
    mainProgram = "reorder-python-imports";
  };
}
