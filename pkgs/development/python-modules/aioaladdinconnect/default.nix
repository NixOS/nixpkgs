{ lib
, aioboto3
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioaladdinconnect";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "AIOAladdinConnect";
    inherit version;
    hash = "sha256-5vfw8SU3lWlPoMAR+byf8jpZrGmXTPoeO+DvPByjZnw=";
  };

  propagatedBuildInputs = [
    aioboto3
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "AIOAladdinConnect"
  ];

  meta = with lib; {
    description = "Library for controlling Genie garage doors connected to Aladdin Connect devices";
    homepage = "https://github.com/mkmer/AIOAladdinConnect";
    changelog = "https://github.com/mkmer/AIOAladdinConnect/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
