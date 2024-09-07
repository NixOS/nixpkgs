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
  version = "3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = "cvss";
    rev = "refs/tags/v${version}";
    hash = "sha256-r4IWaOEZUX+3wW47rX8+lsixIjr14zAaXfFIFcbLVMM=";
  };

  build-system = [ setuptools ];

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
    homepage = "https://github.com/RedHatProductSecurity/cvss";
    changelog = "https://github.com/RedHatProductSecurity/cvss/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cvss_calculator";
  };
}
