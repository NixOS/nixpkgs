{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  isodate,
  docstring-parser,
  colorlog,
  websocket-client,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "chat-downloader";
  version = "0.2.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version pname;
    hash = "sha256-WBasBhefgRkOdMdz2K/agvS+cY6m3/33wiu+Jl4d1Cg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    isodate
    docstring-parser
    colorlog
    websocket-client
  ];

  # Tests try to access the network.
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "chat_downloader" ];

  meta = {
    description = "Simple tool used to retrieve chat messages from livestreams, videos, clips and past broadcasts";
    mainProgram = "chat_downloader";
    homepage = "https://github.com/xenova/chat-downloader";
    changelog = "https://github.com/xenova/chat-downloader/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
