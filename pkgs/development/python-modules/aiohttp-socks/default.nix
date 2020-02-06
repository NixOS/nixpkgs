{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.3.4";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "1gc74a0i0slq3gn9kv3scn7c9x444z5nwjm3d14qilsgq6civsnd";
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
