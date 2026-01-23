{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodomex,
  pyotp,
  requests,
  roadlib,
  selenium,
  selenium-wire,
  setuptools,
  signxml,
}:

buildPythonPackage rec {
  pname = "roadtx";
  version = "1.18.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tJLsxo8XQ0FGyob2SSpjvN9RgVYYhDxGcbP6jytcjaU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodomex
    pyotp
    requests
    roadlib
    selenium
    selenium-wire
    signxml
  ];

  pythonImportsCheck = [ "roadtools.roadtx" ];

  meta = {
    description = "ROADtools Token eXchange";
    homepage = "https://pypi.org/project/roadtx/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
