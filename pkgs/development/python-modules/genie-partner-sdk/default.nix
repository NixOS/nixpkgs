{
  lib,
  buildPythonPackage,
  hatchling,
  aiohttp,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "genie-partner-sdk";
  version = "1.0.11";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "genie_partner_sdk";
    hash = "sha256-eNeN+mtpPzY6p0iVo/ot0eLza/aeJP70PxNHx7/MVoY=";
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
})
