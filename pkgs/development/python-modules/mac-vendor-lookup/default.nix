{ lib
, buildPythonPackage
, fetchFromGitHub
, aiofiles
, aiohttp
}:

buildPythonPackage rec {
  pname = "mac-vendor-lookup";
  version = "0.1.12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bauerj";
    repo = "mac_vendor_lookup";
    rev = "5b57faac0c5a701a7e18085e331853397b68c07c";
    hash = "sha256-F/aiMs+J4bAesr6mKy+tYVjAjZ3l9vyHxV7zaaB6KbA=";
  };

  postPatch = ''
    sed -i '/mac-vendors.txt/d' setup.py
  '';

  propagatedBuildInputs = [
    aiofiles
    aiohttp
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "mac_vendor_lookup"
  ];

  meta = with lib; {
    description = "Find the vendor for a given MAC address";
    homepage = "https://github.com/bauerj/mac_vendor_lookup";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
