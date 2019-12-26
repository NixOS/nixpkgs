{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.3.3";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "21974ce5d782c426ddbf7bdfc5e602a38783b1ee839a4a0ed0990240e2e123b5";
  };

  propagatedBuildInputs = [ aiohttp attrs ];

  # Checks needs internet access
  doCheck = false;

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = https://github.com/romis2012/aiohttp-socks;
  };
}
