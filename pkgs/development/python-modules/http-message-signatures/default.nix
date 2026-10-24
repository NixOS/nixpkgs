{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  http-sf,
  pytest-mypy,
  pytestCheckHook,
  requests,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "http-message-signatures";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = "http-message-signatures";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oGUVWI/mk8NM56GyedF04Ifz3x3XeOjO9AZr9oUjqZs=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    cryptography
    http-sf
  ];

  nativeCheckInputs = [
    pytest-mypy
    pytestCheckHook
    requests
    typing-extensions
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
