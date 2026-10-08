{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  spotipy,
  click,
  pycryptodomex,
  mutagen,
  requests,
  deezer-py,
}:

buildPythonPackage (finalAttrs: {
  pname = "deemix";
  version = "3.6.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xEahzA1PIrGPfnnOcuXQLVQpSVOUFk6/0v9ViLgWCwk=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  meta = {
    description = "Deezer downloader built from the ashes of Deezloader Remix";
    mainProgram = "deemix";
    homepage = "https://gitlab.com/RemixDev/deemix-py";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ natto1784 ];
  };
})
