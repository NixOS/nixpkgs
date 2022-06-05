{ lib
, beautifulsoup4
, buildPythonPackage
, click
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, schema
}:

buildPythonPackage rec {
  pname = "policy-sentry";
  version = "0.12.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "policy_sentry";
    rev = version;
    sha256 = "sha256-LaSSjqa5BniwOIeCH/oR8vVhy2rCSo2je3rTqB4ifLg=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    click
    requests
    pyyaml
    schema
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "policy_sentry" ];

  meta = with lib; {
    description = "Python module for generating IAM least privilege policies";
    homepage = "https://github.com/salesforce/policy_sentry";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
