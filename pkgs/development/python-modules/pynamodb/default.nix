{
  lib,
  blinker,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-env,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pynamodb";
  version = "6.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pynamodb";
    repo = "PynamoDB";
    rev = "refs/tags/${version}";
    hash = "sha256-Ag/ivZ2SDYX0kwXbExt3kE/pMJgfoGc6gWoy+Rr6GTw=";
  };

  build-system = [ setuptools ];

  dependencies = [ botocore ] ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  optional-dependencies = {
    signal = [ blinker ];
  };

  nativeCheckInputs = [
    pytest-env
    pytest-mock
    pytestCheckHook
  ] ++ optional-dependencies.signal;

  pythonImportsCheck = [ "pynamodb" ];

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
    # require a local dynamodb instance
    "test_create_table"
    "test_create_table__incompatible_indexes"
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
