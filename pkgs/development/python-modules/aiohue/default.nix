{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b6cb87652cf1ffc904443b9c5514873c331e159953f2ebf77a051444b350594";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = https://github.com/balloob/aiohue;
    license = licenses.asl20;
  };
}
