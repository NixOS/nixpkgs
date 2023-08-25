{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, geopy
, pythonOlder
, requests
, setuptools
, urllib3
, wheel
}:

buildPythonPackage rec {
  pname = "aemet-opendata";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "AEMET-OpenData";
    rev = "refs/tags/${version}";
    hash = "sha256-Wq22OyNbEg2v6ytUY3PshtDsYllXt+31LEw+9TvC6oM=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    geopy
    requests
    urllib3
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "aemet_opendata.interface"
  ];

  meta = with lib; {
    description = "Python client for AEMET OpenData Rest API";
    homepage = "https://github.com/Noltari/AEMET-OpenData";
    changelog = "https://github.com/Noltari/AEMET-OpenData/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
