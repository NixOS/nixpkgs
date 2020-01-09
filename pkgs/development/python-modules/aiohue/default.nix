{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d95e51f15c442d769004774e7b4220155e32dc6c8ae834b035a2f0d8ff783ff0";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = https://github.com/balloob/aiohue;
    license = licenses.asl20;
  };
}
