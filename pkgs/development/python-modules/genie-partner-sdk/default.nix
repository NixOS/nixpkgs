{
  lib,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  aiohttp,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "genie-partner-sdk";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit version;
    pname = "genie_partner_sdk";
    hash = "sha256-/Pu0pULepRpAdUfu2SQjK4xCSe3FWWNT9AqZEASoZSE=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ aiohttp ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "genie_partner_sdk" ];

  meta = with lib; {
    description = "An SDK to interact with the AladdinConnect (or OHD) partner API";
    homepage = "https://github.com/Genie-Garage/aladdin-python-sdk";
    license = licenses.unfree;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
