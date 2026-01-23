{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  protobuf,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "livekit-protocol";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "python-sdks";
    tag = "protocol-v${version}";
    hash = "sha256-u89KM1Lio1gELIzwhmBJFCf1c29cfGu0WsMf8Vvsi8M=";
  };

  pypaBuildFlags = [ "livekit-protocol" ];

  build-system = [ setuptools ];

  dependencies = [
    protobuf
  ];

  pythonRemoveDeps = [ "types-protobuf" ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "livekit" ];

  passthru.updateScript = gitUpdater { rev-prefix = "protocol-v"; };

  meta = {
    description = "LiveKit real-time and server SDKs for Python";
    homepage = "https://github.com/livekit/python-sdks/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
