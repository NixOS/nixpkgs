{
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  poetry-core,
  pydantic,
  pydantic-core,
  requests,
  typing-extensions,
  websockets,
}:

let
  version = "1.9.0";
  tag = version;
in
buildPythonPackage {
  pname = "elevenlabs";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elevenlabs";
    repo = "elevenlabs-python";
    inherit tag;
    hash = "sha256-0fkt2Z05l95b2S+xoyyy9VGAUZDI1SM8kdcP1PCrUg8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    pydantic
    pydantic-core
    requests
    typing-extensions
    websockets
  ];

  pythonImportsCheck = [ "elevenlabs" ];

  # tests access the API on the internet
  doCheck = false;

  meta = {
    changelog = "https://github.com/elevenlabs/elevenlabs-python/releases/tag/${tag}";
    description = "Official Python API for ElevenLabs Text to Speech";
    homepage = "https://github.com/elevenlabs/elevenlabs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
