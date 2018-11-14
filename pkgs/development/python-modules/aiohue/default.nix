{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohue";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26989babdc3f38575164b60b9536309271d58db005a03045b6e9cca4fc5201d8";
  };

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = https://github.com/balloob/aiohue;
    license = licenses.asl20;
  };
}
