{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pyflakes,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "autoflake";
  version = "2.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-73xJbZvOnSzvBJ8k5ILR0wkMN/vUTl6F37ANs8eO4Ww=";
  };

  build-system = [ hatchling ];

  dependencies = [ pyflakes ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autoflake" ];

  disabledTests = [
    # AssertionError: True is not false
    "test_is_literal_or_name"
  ];

  meta = {
    description = "Tool to remove unused imports and unused variables";
    homepage = "https://github.com/myint/autoflake";
    changelog = "https://github.com/PyCQA/autoflake/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yuriaisaka ];
    mainProgram = "autoflake";
  };
}
