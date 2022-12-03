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
  version = "0.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    sha256 = "f095cd90c312eecec647de2ff49f3ef4cfc30e3935731d21315380f331bdd095";
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

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "chat_downloader" ];

  meta = with lib; {
    description = "A simple tool used to retrieve chat messages from livestreams, videos, clips and past broadcasts";
    homepage = "https://github.com/xenova/chat-downloader";
    changelog = "https://github.com/xenova/chat-downloader/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
