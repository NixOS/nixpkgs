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
  version = "1.1.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "python-sdks";
    tag = "protocol-v${version}";
    hash = "sha256-KiR6lq6E5shstKtKBFKOJoQTsALXTXOcltPjXYT2wu4=";
  };

  pypaBuildFlags = [ "livekit-protocol" ];

  build-system = [ hatchling ];

  dependencies = [
    protobuf
  ];

  pythonRemoveDeps = [ "types-protobuf" ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "livekit" ];

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater { rev-prefix = "protocol-v"; };
  };

  meta = {
    description = "LiveKit real-time and server SDKs for Python";
    homepage = "https://github.com/livekit/python-sdks/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
