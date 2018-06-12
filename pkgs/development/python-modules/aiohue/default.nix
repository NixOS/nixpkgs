{ lib, stdenv, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9300ccb1d2d6c193eae81d7bc2ee6a07dda04f1800572adc666a07d39fea4092";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = https://github.com/balloob/aiohue;
    license = licenses.asl20;
  };
}
