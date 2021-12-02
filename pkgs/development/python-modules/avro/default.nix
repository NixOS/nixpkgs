{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "avro";
  version = "1.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1206365cc30ad561493f735329857dd078533459cee4e928aec2505f341ce445";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
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
