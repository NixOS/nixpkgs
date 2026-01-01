{
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  poetry-core,
  pyaudio,
  pydantic,
  pydantic-core,
  requests,
  typing-extensions,
  websockets,
}:

let
<<<<<<< HEAD
  version = "2.27.0";
=======
  version = "2.24.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  tag = "v${version}";
in
buildPythonPackage {
  pname = "elevenlabs";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elevenlabs";
    repo = "elevenlabs-python";
    inherit tag;
<<<<<<< HEAD
    hash = "sha256-S4UlutpQuF+H3ICB7cBX6tlOUgwHzBYNXR0R5eHji8w=";
=======
    hash = "sha256-eFglmZQumajFHjg4GdMZXgCL5q7ldyC72ak9dFJdeko=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  optional-dependencies = {
    pyaudio = [ pyaudio ];
  };

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
