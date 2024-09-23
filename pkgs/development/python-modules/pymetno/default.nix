{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  async-timeout,
  xmltodict,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pymetno";
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyMetno";
    rev = "refs/tags/${version}";
    hash = "sha256-0QODCJmGxgSKsTbsq4jsoP3cTy/0y6hq63j36bj7Dvo=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    xmltodict
  ];

  pythonImportsCheck = [ "metno" ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Library to communicate with the met.no API";
    homepage = "https://github.com/Danielhiversen/pyMetno/";
    changelog = "https://github.com/Danielhiversen/pyMetno/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
