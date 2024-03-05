{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
, xmltodict
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymetno";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyMetno";
    rev = "refs/tags/${version}";
    hash = "sha256-wRSUIaonjjucLM+A4GsF9Lrq2vZYCquEvblbmjKYpQE=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    xmltodict
  ];

  pythonImportsCheck = [
    "metno"
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "A library to communicate with the met.no API";
    homepage = "https://github.com/Danielhiversen/pyMetno/";
    changelog = "https://github.com/Danielhiversen/pyMetno/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
