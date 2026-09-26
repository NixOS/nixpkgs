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
  version = "3.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "reorder_python_imports";
    tag = "v${version}";
    hash = "sha256-xOHBIjdyrd1R2Iavkvsgk7wVE66YEYdbz29BEyFGtp8=";
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
