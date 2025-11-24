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
  version = "3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = "cvss";
    tag = "v${version}";
    hash = "sha256-udUs76wfvC9LfjlKyWmuPV0RT2P/COTwYw3hgDt3tPs=";
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
    changelog = "https://github.com/RedHatProductSecurity/cvss/releases/tag/${src.tag}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cvss_calculator";
  };
}
