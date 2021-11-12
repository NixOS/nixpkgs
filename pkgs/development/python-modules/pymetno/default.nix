{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
, pytz
, xmltodict
}:

buildPythonPackage rec {
  pname = "pymetno";
  version = "0.8.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyMetno";
    rev = version;
    sha256 = "sha256-ho2SUJmUgI0ruk5lHzXhXQGs9MD6E4hQ4J6tAIz4z5E=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    pytz
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
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
