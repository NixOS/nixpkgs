{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "adax";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyadax";
    rev = "refs/tags/${version}";
    hash = "sha256-wmcZtiML02i1XfqpFzni2WDrxutTvP5laVvTAGtNg0Y=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "adax"
  ];

  meta = with lib; {
    description = "Python module to communicate with Adax";
    homepage = "https://github.com/Danielhiversen/pyAdax";
    changelog = "https://github.com/Danielhiversen/pyAdax/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
