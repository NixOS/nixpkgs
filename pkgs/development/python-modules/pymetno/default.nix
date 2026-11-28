{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  async-timeout,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pymetno";
  version = "0.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyMetno";
    tag = version;
    hash = "sha256-ewLvA0nyrsmcR5JcdUKHqaf7eHM86sV/wzgpzGuW0LE=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    xmltodict
  ];

  pythonImportsCheck = [ "metno" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Library to communicate with the met.no API";
    homepage = "https://github.com/Danielhiversen/pyMetno/";
    changelog = "https://github.com/Danielhiversen/pyMetno/releases/tag/${version}";
    license = lib.licenses.mit;
  };
}
