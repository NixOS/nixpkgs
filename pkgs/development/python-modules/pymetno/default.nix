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
  version = "0.8.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyMetno";
    rev = version;
    sha256 = "sha256-dvZz+wv9B07yKM4E4fQ9VQOgeil9KxZxcGk6D0kWY4g=";
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

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A library to communicate with the met.no API";
    homepage = "https://github.com/Danielhiversen/pyMetno/";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
