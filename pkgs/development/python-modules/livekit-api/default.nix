{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyjwt,
  aiohttp,
  protobuf,
  livekit-protocol,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "livekit-api";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "python-sdks";
    tag = "api-v${version}";
    hash = "sha256-AsTJC0j8dztua7B6JvAYQlHGsE1RCIGoCzfGgbHSnGU=";
  };

  pypaBuildFlags = [ "livekit-api" ];

  build-system = [ setuptools ];

  dependencies = [
    pyjwt
    aiohttp
    protobuf
    livekit-protocol
  ];

  pythonRemoveDeps = [ "types-protobuf" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [ "livekit-api/tests" ];

  pythonImportsCheck = [ "livekit" ];

  passthru.updateScript = gitUpdater { rev-prefix = "api-v"; };

  meta = {
    description = "LiveKit real-time and server SDKs for Python";
    homepage = "https://github.com/livekit/python-sdks/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
