{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyrisco";
  version = "0.5.7";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ySFHB+PZmjsqKJQrfFoupylowsOiV5B2feHX7nF8dUA=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyrisco"
  ];

  meta = with lib; {
    description = "Python interface to Risco alarm systems through Risco Cloud";
    homepage = "https://github.com/OnFreund/pyrisco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
