{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "hole";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "065fxc0l16j8xkjd0y0qar9cmqmjyp8jcshakbakldkfscpx3s5m";
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
