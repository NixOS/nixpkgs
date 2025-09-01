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
  version = "1.0.10";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit version;
    pname = "genie_partner_sdk";
    hash = "sha256-wADTKmR/9p60VJtbK+chUfZuyHe8fYkDSzFHALpXApg=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ aiohttp ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "genie_partner_sdk" ];

  meta = {
    description = "SDK to interact with the AladdinConnect (or OHD) partner API";
    homepage = "https://github.com/Genie-Garage/aladdin-python-sdk";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
