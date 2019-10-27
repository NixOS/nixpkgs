{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7e545ae17658c10f2c5321e40b85426a8c284e5b33b5dfbe9171f9bdf37aa3e";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = https://github.com/balloob/aiohue;
    license = licenses.asl20;
  };
}
