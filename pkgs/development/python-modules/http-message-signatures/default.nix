{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "http-message-signatures";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = "http-message-signatures";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uHsH/kYph50cpLcy4lnu466odexUVvQAYk0ydgtcsM8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  enabledTestPaths = [ "test/test.py" ];

  pythonImportsCheck = [ "http_message_signatures" ];

  meta = {
    description = "Requests authentication module for HTTP Signature";
    homepage = "https://github.com/pyauth/http-message-signatures";
    changelog = "https://github.com/pyauth/http-message-signatures/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
