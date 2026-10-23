{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "open-garage";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyOpenGarage";
    rev = version;
    hash = "sha256-b+UHfVlamhRU2VIT7VT8nh+y6bQYowaTESXkHX414Fk=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "opengarage" ];

  meta = {
    description = "Python module to communicate with opengarage.io";
    homepage = "https://github.com/Danielhiversen/pyOpenGarage";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
