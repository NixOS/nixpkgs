{
  lib,
  beautifultable,
  buildPythonPackage,
  click,
  click-default-group,
  fetchFromGitHub,
  humanize,
  keyring,
  unittestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "mwdblib";
  version = "4.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "mwdblib";
    tag = "v${version}";
    hash = "sha256-1oz//6rQiuV/WAv+6qs12ULPhB5nmf7ntcHSAKnRT8E=";
  };

  propagatedBuildInputs = [
    beautifultable
    click
    click-default-group
    humanize
    keyring
    python-dateutil
    requests
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "mwdblib" ];

  meta = with lib; {
    description = "Python client library for the mwdb service";
    mainProgram = "mwdb";
    homepage = "https://github.com/CERT-Polska/mwdblib";
    changelog = "https://github.com/CERT-Polska/mwdblib/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
