{
  lib,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  fetchPypi,
  typing-extensions,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "avro";
  version = "1.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ytnFOyPO7Wmceva93O1C4sVy/WtAjCV6fU/E6M8uLWs=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeCheckInputs = [ pytest7CheckHook ];

  disabledTests = [
    # Requires network access
    "test_server_with_path"
    # AssertionError: 'reader type: null not compatible with writer type: int'
    "test_schema_compatibility_type_mismatch"
  ];

  pythonImportsCheck = [ "avro" ];

  meta = with lib; {
    description = "Python serialization and RPC framework";
    homepage = "https://github.com/apache/avro";
    changelog = "https://github.com/apache/avro/releases/tag/release-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
    mainProgram = "avro";
  };
}
