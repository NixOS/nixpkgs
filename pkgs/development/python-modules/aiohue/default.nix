{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35696d04d6eb0328b7031ea3c0a3cfe5d83dfcf62f920522e4767d165c6bc529";
  };

  requiredPythonModules = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = "https://github.com/balloob/aiohue";
    license = licenses.asl20;
  };
}
