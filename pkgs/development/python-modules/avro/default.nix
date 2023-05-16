{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "avro";
<<<<<<< HEAD
  version = "1.11.2";
=======
  version = "1.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-U9zVv/zLmnITbwjQsYdxeV6vTu+wKLuq7V9OF4fw4mg=";
=======
    hash = "sha256-8SNiPsxkjQ4gzhT47YUWIUDBPMSxCIZdGyUp+/oGwAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # AssertionError: 'reader type: null not compatible with writer type: int'
    "test_schema_compatibility_type_mismatch"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "avro"
  ];

  meta = with lib; {
    description = "Python serialization and RPC framework";
    homepage = "https://github.com/apache/avro";
<<<<<<< HEAD
    changelog = "https://github.com/apache/avro/releases/tag/release-${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
