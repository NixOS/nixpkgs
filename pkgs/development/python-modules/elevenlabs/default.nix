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

buildPythonPackage rec {
  pname = "elevenlabs";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elevenlabs";
    repo = "elevenlabs-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-puYRVPWMNV+nOHwa//hZQAq1pAkNeU5CFjlMls9C7MM=";
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
    changelog = "https://github.com/elevenlabs/elevenlabs-python/releases/tag/v${version}";
    description = "Official Python API for ElevenLabs Text to Speech";
    homepage = "https://github.com/elevenlabs/elevenlabs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
