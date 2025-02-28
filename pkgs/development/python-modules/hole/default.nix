{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hole";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zkghLJe1SzN2qOeL23+T2ISjGkuODd9tJA1tO3hw2a0=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [ "hole" ];

  meta = with lib; {
    description = "Python API for interacting with a Pihole instance";
    homepage = "https://github.com/home-assistant-ecosystem/python-hole";
    changelog = "https://github.com/home-assistant-ecosystem/python-hole/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
