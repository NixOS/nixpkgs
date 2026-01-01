{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  isodate,
  docstring-parser,
  colorlog,
  websocket-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "chat-downloader";
  version = "0.2.8";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-WBasBhefgRkOdMdz2K/agvS+cY6m3/33wiu+Jl4d1Cg=";
  };

  propagatedBuildInputs = [
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Simple tool used to retrieve chat messages from livestreams, videos, clips and past broadcasts";
    mainProgram = "chat_downloader";
    homepage = "https://github.com/xenova/chat-downloader";
    changelog = "https://github.com/xenova/chat-downloader/releases/tag/v${version}";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
