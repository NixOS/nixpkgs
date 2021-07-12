{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, python-socks, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.6.0";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "04w010bvi719ifpc3sshav95k10hf9nq8czn9yglkj206yxcypdr";
  };

  propagatedBuildInputs = [ aiohttp attrs python-socks ];

  # Checks needs internet access
  doCheck = false;

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
  };
}
