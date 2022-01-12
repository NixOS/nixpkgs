{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hole";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yZpzGfB5RTWaRn2DmT+cbSDC0pL16FyUc0Nr/V6TlhU=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [
    "hole"
  ];

  meta = with lib; {
    description = "Python API for interacting with a Pihole instance.";
    homepage = "https://github.com/home-assistant-ecosystem/python-hole";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
