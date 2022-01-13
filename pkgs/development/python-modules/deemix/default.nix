{ lib
, buildPythonPackage
, fetchPypi
, spotipy
, click
, pycryptodomex
, mutagen
, requests
, deezer-py
, pythonOlder
}:

buildPythonPackage rec {
  pname = "deemix";
  version = "3.6.5";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c56245b2a2142dafb0658d60919ccf34e04e5d87720d5909e0e030521349a65a";
  };

  propagatedBuildInputs = [
    spotipy
    click
    pycryptodomex
    mutagen
    requests
    deezer-py
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [
    "spotipy"
    "click"
    "Cryptodome"
    "mutagen"
    "requests"
    "deezer"
  ];

  meta = with lib; {
    homepage = "https://git.freezer.life/RemixDev/deemix-py";
    description = "Deezer downloader built from the ashes of Deezloader Remix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ natto1784 ];
  };
}
