{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python_http_client";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "sendgrid";
    repo = "python-http-client";
    rev = version;
    sha256 = "0mbcg0vb9v41v7hbvycrxx5wyrf3ysvfgxkix8hn8c4x5l2lmidc";
  };

  checkInputs = [
    mock
    pytestCheckHook
  ];

  # Failure was fixed by https://github.com/sendgrid/python-http-client/commit/6d62911ab0d0645b499e14bb17c302b48f3c10e4
  disabledTests = [ "test__daterange" ];
  pythonImportsCheck = [ "python_http_client" ];

  meta = with lib; {
    description = "Python HTTP library to call APIs";
    homepage = "https://github.com/sendgrid/python-http-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
