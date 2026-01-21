{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiofiles,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "mac-vendor-lookup";
  version = "0.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bauerj";
    repo = "mac_vendor_lookup";
    tag = finalAttrs.version;
    hash = "sha256-RLCEyDalwQUVmcZdVPN1cyKLIPbWcZfjzIkClUZCeJU=";
  };

  postPatch = ''
    sed -i '/mac-vendors.txt/d' setup.py
  '';

  propagatedBuildInputs = [
    aiofiles
    aiohttp
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "mac_vendor_lookup" ];

  meta = {
    description = "Find the vendor for a given MAC address";
    mainProgram = "mac_vendor_lookup";
    homepage = "https://github.com/bauerj/mac_vendor_lookup";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
