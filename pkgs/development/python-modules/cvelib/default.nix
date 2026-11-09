{
  lib,
  buildPythonPackage,
  click,
  cve,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  requests,
  hatchling,
  testers,
}:

buildPythonPackage rec {
  pname = "cvelib";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = "cvelib";
    tag = version;
    hash = "sha256-lbwrZSzJaP+nKFwt7xiq/LTzgOuf8aELxjrxEKkYpfc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    jsonschema
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cvelib" ];

  passthru.tests.version = testers.testVersion { package = cve; };

  meta = {
    description = "Library and a command line interface for the CVE Services API";
    homepage = "https://github.com/RedHatProductSecurity/cvelib";
    changelog = "https://github.com/RedHatProductSecurity/cvelib/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raboof ];
    mainProgram = "cve";
  };
}
