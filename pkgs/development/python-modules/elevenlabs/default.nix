{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "elevenlabs";
  version = "1.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-69AoablWAriVaHTdcnmBu0mtFrmjwvWQEZPYOCE2lKo=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    httpx
    ipython
    pydantic
    requests
    typing-extensions
    websockets
  ];

  meta = {
    description = "The official Python API for ElevenLabs Text to Speech.";
    homepage = "https://elevenlabs.io/docs/api-reference/getting-started";
    changelog = "https://github.com/elevenlabs/elevenlabs-python/releases/tag/v${version}";
    mainProgram = "elevenlabs";
    maintainers = with lib.maintainers; [ ivankovnatsky ];
    license = lib.licenses.mit;
  };
}
