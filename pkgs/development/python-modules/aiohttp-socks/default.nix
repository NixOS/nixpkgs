{ lib
, aiohttp
, attrs
, buildPythonPackage
, fetchPypi
, python-socks
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "sha256-IhXKxIke8/oUt9YA7TQ+0PCmcMI7EOQUKqhis9sgNBo=";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    python-socks
  ];

  # Checks needs internet access
  doCheck = false;

  pythonImportsCheck = [
    "aiohttp_socks"
  ];

  meta = with lib; {
    description = "SOCKS proxy connector for aiohttp";
    license = licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
    maintainers = with maintainers; [ fab ];
  };
}
