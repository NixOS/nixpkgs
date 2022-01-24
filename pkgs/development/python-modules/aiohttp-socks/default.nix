{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, python-socks, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.7.1";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "2215cac4891ef3fa14b7d600ed343ed0f0a670c23b10e4142aa862b3db20341a";
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
