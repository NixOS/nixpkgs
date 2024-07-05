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
  version = "1.8.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BJYBQBxgYbozY0rPgxpiduUxb6wEFBJxXY8TRVlLz5M=";
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
