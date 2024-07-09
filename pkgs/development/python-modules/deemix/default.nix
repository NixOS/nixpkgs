{
  lib,
  buildPythonPackage,
  fetchPypi,
  spotipy,
  click,
  pycryptodomex,
  mutagen,
  requests,
  deezer-py,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "deemix";
  version = "3.6.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xEahzA1PIrGPfnnOcuXQLVQpSVOUFk6/0v9ViLgWCwk=";
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

  pythonImportsCheck = [ "deezer" ];

  meta = with lib; {
    description = "Deezer downloader built from the ashes of Deezloader Remix";
    mainProgram = "deemix";
    homepage = "https://git.freezerapp.xyz/RemixDev/deemix-py";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ natto1784 ];
  };
}
