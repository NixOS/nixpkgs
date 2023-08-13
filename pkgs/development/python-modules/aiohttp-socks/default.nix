{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, python-socks, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.8.0";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    hash = "sha256-knsdOzR0SPhv9SRcnKGeQPOX65OQZoK+WSeQZ4yYLzc=";
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
