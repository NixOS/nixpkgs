{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, slixmpp
}:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.2.8";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "ehendrix23";
     repo = "aioharmony";
     rev = "v0.2.8";
     sha256 = "1k6smns8klvymd7h6649454ssg3z66xl886lhzm2gqj33yw4c0cf";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    slixmpp
  ];

  # aioharmony does not seem to include tests
  doCheck = false;

  pythonImportsCheck = [
    "aioharmony.harmonyapi"
    "aioharmony.harmonyclient"
  ];

  meta = with lib; {
    homepage = "https://github.com/ehendrix23/aioharmony";
    description = "Python library for interacting the Logitech Harmony devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
