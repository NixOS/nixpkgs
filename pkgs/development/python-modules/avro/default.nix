{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "avro";
  version = "1.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8SNiPsxkjQ4gzhT47YUWIUDBPMSxCIZdGyUp+/oGwAg=";
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
  ];

  pythonImportsCheck = [
    "avro"
  ];

  meta = with lib; {
    description = "Python serialization and RPC framework";
    homepage = "https://github.com/apache/avro";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
