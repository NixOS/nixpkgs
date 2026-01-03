{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  hatchling,
  hatch-vcs,
  requests,
}:

buildPythonPackage rec {
  pname = "http-message-signatures";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = "http-message-signatures";
    tag = "v${version}";
    hash = "sha256-c5zwH28FFbEmLfL4nBBE2S1YEbwicoJo3UAYn/0zXEM=";
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
