{
  lib,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  http-sf,
  httpx2,
  pytest-mypy,
  pytestCheckHook,
  requests,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "http-message-signatures";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = "http-message-signatures";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3ADx7xaAVBStvFHFqffrIKO5SrgIROMs+yFt03IcP+A=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    cryptography
    http-sf
  ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    httpx2 = [ httpx2 ];
  };

  nativeCheckInputs = [
    pytest-mypy
    pytestCheckHook
    requests
    typing-extensions
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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
