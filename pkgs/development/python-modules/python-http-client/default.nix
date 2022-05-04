{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python_http_client";
  version = "3.3.7";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sendgrid";
    repo = "python-http-client";
    rev = version;
    sha256 = "sha256-8Qs5Jw0LMV2UucLnlFKJQ2PUhYaQx6uJdIV/4gaPH3w=";
  };

  checkInputs = [
    mock
    pytestCheckHook
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
