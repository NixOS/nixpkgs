{ lib
, aiofiles
, aiohttp
, backoff
, buildPythonPackage
, click
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyprosegur";
  version = "0.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FTCQ2noxodFKN7qXdc7DG3Zt4j/pR6DeuWIs0GtGRy8=";
  };

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    backoff
    click
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyprosegur"
  ];

  meta = with lib; {
    description = "Python module to communicate with Prosegur Residential Alarms";
    homepage = "https://github.com/dgomes/pyprosegur";
    changelog = "https://github.com/dgomes/pyprosegur/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
