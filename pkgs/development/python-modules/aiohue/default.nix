{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87f0f86865e88ea715ab358b1e5f2838b79ee7cdc0bdf762e9ed60aaf4c8bd4a";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = https://github.com/balloob/aiohue;
    license = licenses.asl20;
  };
}
