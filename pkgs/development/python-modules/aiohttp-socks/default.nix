{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.3.6";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "0js7p9qj5x6k8i2cby4c6mw6xrp4dy4m82f3n1l8rz00qibmj37j";
  };

  propagatedBuildInputs = [ aiohttp attrs ];

  # Checks needs internet access
  doCheck = false;

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
  };
}
