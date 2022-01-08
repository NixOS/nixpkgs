{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python_http_client";
  version = "3.3.4";
  format = "setuptools";

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
