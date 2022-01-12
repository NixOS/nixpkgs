{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python_http_client";
  version = "3.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sendgrid";
    repo = "python-http-client";
    rev = version;
    sha256 = "sha256-wTXHq+tC+rfvmDZIWvcGhQZqm6DxOmx50BsX0c6asec=";
  };

  checkInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Test is failing as the test is dynamic
    # https://github.com/sendgrid/python-http-client/issues/153
    "test__daterange"
  ];

  pythonImportsCheck = [
    "python_http_client"
  ];

  meta = with lib; {
    description = "Python HTTP library to call APIs";
    homepage = "https://github.com/sendgrid/python-http-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
