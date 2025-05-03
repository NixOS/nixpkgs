{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "livekit-protocol";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "python-sdks";
    tag = "rtc-v${version}";
    hash = "sha256-iIqyfiWV6lH7t5n4Jk8faOn/HIg3/iWF8D7f9sAjhhg=";
  };

  pypaBuildFlags = [ "livekit-protocol" ];

  build-system = [ setuptools ];

  dependencies = [
    protobuf
  ];

  pythonRemoveDeps = [ "types-protobuf" ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "livekit" ];

  meta = {
    description = "LiveKit real-time and server SDKs for Python";
    homepage = "https://github.com/livekit/python-sdks/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
