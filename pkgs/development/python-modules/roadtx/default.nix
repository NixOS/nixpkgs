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
  version = "1.17.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C/s5zNvqREDc6r9EdPrN4+L913XWYTniKQVbaosh9iE=";
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
