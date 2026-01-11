{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "airthings-cloud";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyAirthings";
    tag = version;
    hash = "sha256-HdH/z5xsumOXU0ZYOUc8LHpjKGkfp5e5yGER+Nm8xB4=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "airthings" ];

  meta = {
    description = "Python module for Airthings";
    homepage = "https://github.com/Danielhiversen/pyAirthings";
    changelog = "https://github.com/Danielhiversen/pyAirthings/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
