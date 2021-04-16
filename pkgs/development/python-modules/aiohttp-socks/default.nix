{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, attrs, python-socks }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.6.0";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "sha256-uV3PujdAyEmfT/YzhG1yEIRZ0lZQ68GuiymcuBcIgBM=";
  };

  propagatedBuildInputs = [ aiohttp attrs python-socks ];

  # Checks needs internet access
  doCheck = false;

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
  };
}
