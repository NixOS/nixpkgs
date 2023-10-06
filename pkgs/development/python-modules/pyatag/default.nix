{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyatag";
  version = "0.3.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatsNl";
    repo = "pyatag";
    rev = "refs/tags/${version}";
    hash = "sha256-yJEPDNjEv2lGrBQ78sl7nseVRemsG7hTdBGH5trciYU=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pyatag"
    "pyatag.discovery"
  ];

  meta = with lib; {
    description = "Python module to talk to Atag One";
    homepage = "https://github.com/MatsNl/pyatag";
    changelog = "https://github.com/MatsNl/pyatag/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
