{ lib
, aiohttp
, bidict
, buildPythonPackage
, fetchPypi
, humanize
, lxml
, pythonOlder
, requests
, slixmpp
, websockets
}:

buildPythonPackage rec {
  pname = "gehomesdk";
  version = "0.5.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FmCoryNX1DnqMlGalad5iWO2ZRZwXgWgARQMYlJ6yVo=";
  };

  propagatedBuildInputs = [
    aiohttp
    bidict
    humanize
    lxml
    requests
    slixmpp
    websockets
  ];

  # Tests are not shipped and source is not tagged
  # https://github.com/simbaja/gehome/issues/32
  doCheck = false;

  pythonImportsCheck = [
    "gehomesdk"
  ];

  meta = with lib; {
    description = "Python SDK for GE smart appliances";
    homepage = "https://github.com/simbaja/gehome";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
