{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, requests-oauthlib
, responses
}:

buildPythonPackage rec {
  pname = "asana";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    rev = "refs/tags/v${version}";
    hash = "sha256-qxoGi7UByHEuDKsELEjwzf01/JNEiUgUs88536TGFKo=";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "asana"
  ];

  meta = with lib; {
    description = "Python client library for Asana";
    homepage = "https://github.com/asana/python-asana";
    changelog = "https://github.com/Asana/python-asana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
