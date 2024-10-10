{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  astunparse,
  setuptools,
}:
buildPythonPackage rec {
  pname = "import-expression";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "import_expression";
    hash = "sha256-Biw7dIOPKbDcqYJSCyeqC/seREcVihSZuaKNFfgjTew=";
  };

  build-system = [ setuptools ];
  dependencies = [ astunparse ];
  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [
    "import_expression"
    "import_expression._codec"
  ];

  meta = {
    description = "Transpiles a superset of python to allow easy inline imports";
    homepage = "https://github.com/ioistired/import-expression-parser";
    license = with lib.licenses; [
      mit
      psfl
    ];
    mainProgram = "import-expression";
    maintainers = with lib.maintainers; [ ];
  };
}
