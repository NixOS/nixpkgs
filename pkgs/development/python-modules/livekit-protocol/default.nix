{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  protobuf,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "livekit-protocol";
  version = "1.1.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "python-sdks";
    tag = "protocol-v${version}";
    hash = "sha256-k+2qaxSoK6vEqZpXmPmGFeHPz8qi/Roax0G4X80AgJc=";
  };

  pypaBuildFlags = [ "livekit-protocol" ];

  build-system = [ hatchling ];

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
