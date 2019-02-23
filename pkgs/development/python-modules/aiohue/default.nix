{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c23aed8e82f398b732279f5f7ee7ed00949ff2db7009f7a2dc705f7c2d16783";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = https://github.com/balloob/aiohue;
    license = licenses.asl20;
  };
}
