{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, requests-oauthlib
, responses
, six
}:

buildPythonPackage rec {
  pname = "asana";
  version = "0.10.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hHY4GkjIXjvsZz68Ds5JHkalQPIL7/Oh4HX4A6azASI=";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
    six
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "asana"
  ];

  meta = with lib; {
    description = "Python client library for Asana";
    homepage = "https://github.com/asana/python-asana";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
