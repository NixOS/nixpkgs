{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  hatchling,
  hatch-vcs,
  requests,
}:

buildPythonPackage rec {
  pname = "http-message-signatures";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = "http-message-signatures";
    tag = "v${version}";
    hash = "sha256-vPZeAS3hR7Bmj2FtME+V9WU3TViBndrBb9GLkdMVh2Q=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  enabledTestPaths = [ "test/test.py" ];

  pythonImportsCheck = [ "http_message_signatures" ];

  meta = {
    description = "Requests authentication module for HTTP Signature";
    homepage = "https://github.com/pyauth/http-message-signatures";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
