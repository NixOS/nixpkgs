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
  version = "0.0.8";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Spxzyn0gZ1TIHrtt7W0j6VwKnm2Km5vLGZZ//HINyBA=";
  };

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    backoff
    click
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyprosegur" ];

  meta = with lib; {
    description = "Python module to communicate with Prosegur Residential Alarms";
    homepage = "https://github.com/dgomes/pyprosegur";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
