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

buildPythonPackage (finalAttrs: {
  pname = "elevenlabs";
  version = "2.35.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elevenlabs";
    repo = "elevenlabs-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8O/gpG0XAJeD6g52mdO7T43NBHfpctuHm8mu4CVvZ78=";
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
    changelog = "https://github.com/elevenlabs/elevenlabs-python/releases/tag/${finalAttrs.src.tag}";
    description = "Official Python API for ElevenLabs Text to Speech";
    homepage = "https://github.com/elevenlabs/elevenlabs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
