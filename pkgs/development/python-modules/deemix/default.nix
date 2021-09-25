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
  version = "3.5.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3347d07fab5dcadcfa7798383ba0a2e026d4bfdc0a7c2a7584d7fbf128a3c233";
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
