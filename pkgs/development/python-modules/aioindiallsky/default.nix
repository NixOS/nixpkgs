{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioindiallsky";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TN-1";
    repo = "aioindiallsky";
    tag = "V${finalAttrs.version}";
    hash = "sha256-bmib7Rimx9R/59DKed+H0l/9aeEQnP3vnuNJlqJjsZc=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioindiallsky" ];

  meta = {
    description = "Asynchronous Python client library for indi-allsky API & WebSocket event stream";
    homepage = "https://github.com/TN-1/aioindiallsky";
    changelog = "https://github.com/TN-1/aioindiallsky/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
