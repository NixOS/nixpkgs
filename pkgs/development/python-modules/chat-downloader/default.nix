{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, isodate
, docstring-parser
, colorlog
, websocket-client
, pytestCheckHook
, fetchpatch
}:

buildPythonPackage rec {
  pname = "chat-downloader";
  version = "0.2.0";

  # PyPI tarball is missing files
  src = fetchFromGitHub {
    owner = "xenova";
    repo = "chat-downloader";
    rev = "v${version}";
    sha256 = "sha256-SVZyDTma6qAgmOz+QsPnudPrX1Eswtc0IKFRx1HnWLY=";
  };

  patches = [
    # Remove argparse from dependencies. https://github.com/xenova/chat-downloader/pull/167
    (fetchpatch {
      url = "https://github.com/xenova/chat-downloader/commit/cdaca5e3a334c8db1b37bebe191d181ebdfa576c.patch";
      sha256 = "sha256-AgH305dJmNRZy23lAf1h40klDE67RSwEL8o2gxX0VGA=";
    })
  ];

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
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
