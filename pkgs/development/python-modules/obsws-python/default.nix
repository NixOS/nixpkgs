{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  tomli,
  websocket-client,
}:
buildPythonPackage (finalAttrs: {
  pname = "obsws-python";
  version = "5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aatikturk";
    repo = "obsws-python";
    rev = "f70583d7ca250c1f3a0df768d3cfd41663a6023b"; # no tags
    hash = "sha256-krIiSmn/56Ao4fH6Y7JSQ11Euqt0tIq4JJjxqrt8MZc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    tomli
    websocket-client
  ];

  doCheck = false; # attempts to connect to OBS

  meta = {
    description = "Python SDK for OBS Studio WebSocket v5.0";
    homepage = "https://github.com/aatikturk/obsws-python";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
