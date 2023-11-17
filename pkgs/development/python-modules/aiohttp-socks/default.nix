{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, python-socks, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.8.3";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    hash = "sha256-aqtSj2aeCHMBj9N3c7gzouK6KEJDvmcoF/pAG8eUHsY=";
  };

  propagatedBuildInputs = [ aiohttp attrs python-socks ];

  # Checks needs internet access
  doCheck = false;
  pythonImportsCheck = [ "aiohttp_socks" ];

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
  };
}
