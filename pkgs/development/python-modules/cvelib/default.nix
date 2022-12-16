{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, jsonschema
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "cvelib";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = "cvelib";
    rev = "tags/${version}";
    hash = "sha256-8qlXwEbgLRZ1qYtBJ1c0nv6qfIOW5zAK9eOS+n+afWQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = [
    click
    jsonschema
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cvelib"
  ];

  meta = with lib; {
    description = "Library and a command line interface for the CVE Services API";
    homepage = "https://github.com/RedHatProductSecurity/cvelib";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
