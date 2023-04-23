{ lib
, buildPythonPackage
, fetchPypi
, pymongo
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mockupdb";
  version = "1.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-020OW2RF/5FB400BL6K13+WJhHqh4+y413QHSWKvlE4=";
  };

  propagatedBuildInputs = [
    pymongo
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mockupdb"
  ];

  disabledTests = [
    # AssertionError: expected to receive Request(), got nothing
    "test_flags"
    "test_iteration"
    "test_ok"
    "test_ssl_basic"
    "test_unix_domain_socket"
  ];

  meta = with lib; {
    description = "Simulate a MongoDB server";
    license = licenses.asl20;
    homepage = "https://github.com/ajdavis/mongo-mockup-db";
    maintainers = with maintainers; [ globin ];
  };
}
