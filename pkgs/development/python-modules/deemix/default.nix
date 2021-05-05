{ lib
, buildPythonPackage
, fetchPypi
, click
, pycryptodomex
, mutagen
, requests
, spotipy
, deezer-py
}:

buildPythonPackage rec {
  pname = "deemix";
  version = "2.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "CYKcblb8nRTpmdPUqOxZxF9hZZa+CMGfmF0oQEr/tmA=";
  };

  propagatedBuildInputs = [
    click
    pycryptodomex
    mutagen
    requests
    spotipy
    deezer-py
  ];

  doCheck = false; # tcp: protocol not found
  pythonImportsCheck = [ "deemix" ];

  meta = with lib; {
    description = "deezer downloader built from the ashes of Deezloader Remix";
    homepage = "https://git.rip/RemixDev/deemix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
  };
}
