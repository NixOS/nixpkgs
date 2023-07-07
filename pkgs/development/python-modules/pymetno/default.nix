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
  version = "0.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyMetno";
    rev = "refs/tags/${version}";
    hash = "sha256-Do9RQS4gE2BapQtKQsnMzJ8EJzzxkCBA5r3z1zHXIsA=";
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
