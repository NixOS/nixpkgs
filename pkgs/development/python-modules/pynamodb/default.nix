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
  version = "5.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pynamodb";
    repo = "PynamoDB";
    rev = "refs/tags/${version}";
    hash = "sha256-cxWPnq+xGDaJ1rj/K25ELATFAW+/eteilrnqrCftW0Q=";
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

  nativeCheckInputs = [
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
    changelog = "https://github.com/pynamodb/PynamoDB/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
