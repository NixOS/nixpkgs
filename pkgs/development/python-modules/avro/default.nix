{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "avro";
  version = "1.12.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6QDntZpHgfY9npNeiPbsUMTWC+P0rfnGO1HtOdV4/gg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest7CheckHook ];

  disabledTests = [
    # Requires network access
    "test_server_with_path"
    # AssertionError: 'reader type: null not compatible with writer type: int'
    "test_schema_compatibility_type_mismatch"
  ];

  pythonImportsCheck = [ "avro" ];

  meta = {
    description = "Python serialization and RPC framework";
    homepage = "https://github.com/apache/avro";
    changelog = "https://github.com/apache/avro/releases/tag/release-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "avro";
  };
}
