{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pyjwt
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "3.19.0";

  src = fetchFromGitHub {
     owner = "auth0";
     repo = "auth0-python";
     rev = "3.19.0";
     sha256 = "0anplgppx9xcq8h8nacvfqwbcjv6p5yh8ksi07cw71p0qag4h103";
  };

  propagatedBuildInputs = [
    requests
    pyjwt
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # tries to ping websites (e.g. google.com)
    "can_timeout"
    "test_options_are_created_by_default"
    "test_options_are_used_and_override"
  ];

  pythonImportsCheck = [ "auth0" ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
