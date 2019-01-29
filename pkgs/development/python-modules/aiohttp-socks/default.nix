{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.2.2";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "0473702jk66xrgpm28wbdgpnak4v0dh2qmdjw7ky7hf3lwwqkggf";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Checks needs internet access
  doCheck = false;

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = https://github.com/romis2012/aiohttp-socks;
  };
}
