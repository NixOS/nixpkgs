{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, python-socks, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.7.1";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "sha256-IhXKxIke8/oUt9YA7TQ+0PCmcMI7EOQUKqhis9sgNBo=";
  };

  propagatedBuildInputs = [ aiohttp attrs python-socks ];

  # Checks needs internet access
  doCheck = false;
  pythonImportsCheck = [ "aiohttp_socks" ];

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
  };
}
