{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, loguru
, requests
}:

buildPythonPackage rec {
  pname = "pyaussiebb";
  version = "0.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yaleman";
    repo = "aussiebb";
    rev = "v${version}";
    hash = "sha256-DMU29dTqDaPLQS20iuHIph6mhBdj6ni3+MA9KkRMtzg=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
    loguru
  ];

  # Tests require network access
  # https://github.com/yaleman/aussiebb/issues/6
  doCheck = false;

  pythonImportsCheck = [
    "aussiebb"
  ];

  meta = with lib; {
    description = "Module for interacting with the Aussie Broadband APIs";
    homepage = "https://github.com/yaleman/aussiebb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
