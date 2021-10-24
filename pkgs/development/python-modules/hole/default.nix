{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "hole";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T6U6WVx+5+/UaSS2mMmjAjWu67ut+YGpq2ooP9YEazI=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [ "hole" ];

  meta = with lib; {
    description = "Python API for interacting with a Pihole instance.";
    homepage = "https://github.com/home-assistant-ecosystem/python-hole";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
