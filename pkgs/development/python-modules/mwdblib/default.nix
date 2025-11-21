{
  lib,
  beautifultable,
  buildPythonPackage,
  click-default-group,
  click,
  fetchFromGitHub,
  humanize,
  keyring,
  requests,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "mwdblib";
  version = "4.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "mwdblib";
    tag = "v${version}";
    hash = "sha256-1oz//6rQiuV/WAv+6qs12ULPhB5nmf7ntcHSAKnRT8E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifultable
    click
    click-default-group
    humanize
    keyring
    requests
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "mwdblib" ];

  meta = {
    description = "Python client library for the mwdb service";
    homepage = "https://github.com/CERT-Polska/mwdblib";
    changelog = "https://github.com/CERT-Polska/mwdblib/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mwdb";
  };
}
