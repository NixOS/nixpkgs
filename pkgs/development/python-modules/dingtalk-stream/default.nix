{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  setuptools,
  # Dependencies
  aiohttp,
  requests,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "dingtalk-stream";
  version = "0.24.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "open-dingtalk";
    repo = "dingtalk-stream-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ShJwTb+ObaewGGki9pdW7VYOBK6CBXhcsTiBj/5N0kM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    requests
    websockets
  ];

  pythonImportsCheck = [
    "dingtalk_stream"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python SDK for DingTalk Stream Mode API";
    homepage = "https://github.com/open-dingtalk/dingtalk-stream-sdk-python";
    changelog = "https://github.com/open-dingtalk/dingtalk-stream-sdk-python/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LodWKobku ];
  };
})
