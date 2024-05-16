{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, jsonschema
, pytestCheckHook
, pythonOlder
, requests
, testers
, cve
}:

buildPythonPackage rec {
  pname = "cvelib";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = "cvelib";
    rev = "refs/tags/${version}";
    hash = "sha256-nj5bkep8jYJE1qh2zNxivjKOpHj93UZ8bU+qNs2On8s=";
  };

  propagatedBuildInputs = [
    click
    jsonschema
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cvelib"
  ];

  passthru.tests.version = testers.testVersion { package = cve; };

  meta = with lib; {
    description = "Library and a command line interface for the CVE Services API";
    homepage = "https://github.com/RedHatProductSecurity/cvelib";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
    mainProgram = "cve";
  };
}
