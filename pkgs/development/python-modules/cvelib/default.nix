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
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = "cvelib";
    rev = "tags/${version}";
    hash = "sha256-hJPcxnc4iQzsYNNVJ9fw6yQl+5K7pdtjHT6oMmBx/Zs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

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
