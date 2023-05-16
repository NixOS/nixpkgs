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
<<<<<<< HEAD
  version = "0.5.20";
=======
  version = "0.5.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-5nu7pewkxCZ/F6m7xOwvMwuhFsanQKHtdwGqNto3/zk=";
=======
    hash = "sha256-M0G+UvFCegKEDA+0PI1voesMqIItKC0591ruZ4YvjMU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/simbaja/gehome/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
