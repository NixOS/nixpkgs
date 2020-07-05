{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bdd08ad65505057b9dc8fc1b5558250bd13aeba681a493080f710ffffc4260a3";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = "https://github.com/balloob/aiohue";
    license = licenses.asl20;
  };
}
