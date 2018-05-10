{ lib, stdenv, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05b2fj8pzbij8hglx6p5ckfx0h1b7wcfpys306l853vp56d882yh";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = https://github.com/balloob/aiohue;
    license = licenses.asl20;
  };
}
