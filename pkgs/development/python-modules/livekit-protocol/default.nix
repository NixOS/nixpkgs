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
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "python-sdks";
    tag = "protocol-v${version}";
    hash = "sha256-1La7XYTo9onQFNx84CwabPM6N6LXIn/7swH50hFQvB8=";
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
