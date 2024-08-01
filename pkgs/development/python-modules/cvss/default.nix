{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  unittestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cvss";
  version = "3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = "cvss";
    rev = "refs/tags/v${version}";
    hash = "sha256-e/zwOfbt3YLlRiLFObjps3tFFk6BAWBKdanio6sus8c=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    jsonschema
    unittestCheckHook
  ];

  pythonImportsCheck = [ "cvss" ];

  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    description = "Library for CVSS2/3/4";
    mainProgram = "cvss_calculator";
    homepage = "https://github.com/RedHatProductSecurity/cvss";
    changelog = "https://github.com/RedHatProductSecurity/cvss/releases/tag/v${version}";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
