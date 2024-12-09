{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "import-expression";
  version = "2.1.0.post1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "import_expression";
    inherit version;
    hash = "sha256-mclYGeuISXUDrOS1mhpVgDp1439KnHAwzHKIbRtdibQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "import_expression" ];

  meta = {
    description = "Transpiles a superset of python to allow easy inline imports";
    homepage = "https://github.com/ioistired/import-expression-parser";
    changelog = "https://github.com/ioistired/import-expression/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      psfl
    ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "import-expression";
  };
}
