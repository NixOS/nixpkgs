{ lib
, buildPythonPackage
, fetchPypi
, requests
, isodate
, docstring-parser
, colorlog
, websocket-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "chat-downloader";
<<<<<<< HEAD
  version = "0.2.8";
=======
  version = "0.2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
<<<<<<< HEAD
    hash = "sha256-WBasBhefgRkOdMdz2K/agvS+cY6m3/33wiu+Jl4d1Cg=";
=======
    hash = "sha256-nxk1VcZr5teuev4cFrtUSIeZNQ8ynpk0n0obGTxqepA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  meta = with lib; {
    description = "A simple tool used to retrieve chat messages from livestreams, videos, clips and past broadcasts";
    homepage = "https://github.com/xenova/chat-downloader";
    changelog = "https://github.com/xenova/chat-downloader/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
