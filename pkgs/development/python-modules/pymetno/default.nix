{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
, pytz
, xmltodict
}:

buildPythonPackage rec {
  pname = "PyMetno";
  version = "0.8.2";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = "Danielhiversen";
    rev = version;
    sha256 = "0b1zm60yqj1mivc3zqw2qm9rqh8cbmx0r58jyyvm3pxzq5cafdg5";
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
    description = "A library to communicate with the met.no api";
    homepage = "https://github.com/Danielhiversen/pyMetno/";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
