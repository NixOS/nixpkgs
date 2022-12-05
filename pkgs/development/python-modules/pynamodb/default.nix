{ lib
, blinker
, botocore
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pynamodb";
  version = "5.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pynamodb";
    repo = "PynamoDB";
    rev = "refs/tags/${version}";
    sha256 = "sha256-3Si0BCMofr38OuXoX8Tj9n3ITv3rH5hNfDQZvZWk79o=";
  };

  propagatedBuildInputs = [
    python-dateutil
    botocore
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    signal = [
      blinker
    ];
  };

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.signal;

  pythonImportsCheck = [
    "pynamodb"
  ];

  disabledTests = [
    # Tests requires credentials or network access
    "test_binary_attribute_update"
    "test_binary_set_attribute_update"
    "test_connection_integration"
    "test_make_api_call__happy_path"
    "test_model_integration"
    "test_sign_request"
    "test_table_integration"
    "test_transact"
  ];

  meta = with lib; {
    description = "Interface for Amazon’s DynamoDB";
    longDescription = ''
      DynamoDB is a great NoSQL service provided by Amazon, but the API is
      verbose. PynamoDB presents you with a simple, elegant API.
    '';
    homepage = "http://jlafon.io/pynamodb.html";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
