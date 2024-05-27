{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  async-timeout,
}:

buildPythonPackage rec {
  pname = "ambiclimate";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "Ambiclimate";
    inherit version;
    sha256 = "0vhmpazc2n7qyyh7wqsz635w0f8afk2i5d592ikb84bgnfn83483";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # tests are not present
  doCheck = false;

  pythonImportsCheck = [ "ambiclimate" ];

  meta = with lib; {
    description = "Python library to communicate with ambiclimate";
    homepage = "https://github.com/Danielhiversen/pyAmbiclimate";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
