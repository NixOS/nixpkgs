{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "avro";
  version = "1.11.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U9zVv/zLmnITbwjQsYdxeV6vTu+wKLuq7V9OF4fw4mg=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "test_server_with_path"
    # AssertionError: 'reader type: null not compatible with writer type: int'
    "test_schema_compatibility_type_mismatch"
  ];

  pythonImportsCheck = [
    "avro"
  ];

  meta = with lib; {
    description = "Python serialization and RPC framework";
    homepage = "https://github.com/apache/avro";
    changelog = "https://github.com/apache/avro/releases/tag/release-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
