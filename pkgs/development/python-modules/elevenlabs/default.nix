{ buildPythonPackage
, fetchFromGitHub
, ffmpeg
, httpx
, ipython
, lib
, mpv
, poetry-core
, pydantic
, pytestCheckHook
, requests
, typing-extensions
, websockets
}:

buildPythonPackage rec {
  pname = "elevenlabs";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elevenlabs";
    repo = "elevenlabs-python";
    rev = "v${version}";
    hash = "sha256-B91OGFYwXijvqPe4TWjZP+/QcuBVvJxeCWmVQ1s8UEE=";
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

  pythonImportsCheck = [
    "elevenlabs"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ffmpeg
    mpv
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
