{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.4.0";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "18pkjkcwdqgckxqc0xk2yvk38w6h2g71a2xv5jvignpbvfjwmqfc";
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
