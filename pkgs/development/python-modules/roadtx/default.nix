{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodomex,
  pyotp,
  pythonOlder,
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

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "ROADtools Token eXchange";
    homepage = "https://pypi.org/project/roadtx/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
