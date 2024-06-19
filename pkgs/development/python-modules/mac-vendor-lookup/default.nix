{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiofiles,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "mac-vendor-lookup";
  version = "0.1.12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bauerj";
    repo = "mac_vendor_lookup";
    rev = "90dbea48f8a9d567b5f9039ebd151ddfe7d12a19";
    hash = "sha256-mPPJDrWdyvkTdb4WfeTNYwuC+Ek9vH7ORKRTREg+vK8=";
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

  meta = with lib; {
    description = "Find the vendor for a given MAC address";
    mainProgram = "mac_vendor_lookup";
    homepage = "https://github.com/bauerj/mac_vendor_lookup";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
