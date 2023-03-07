{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pycryptodome
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioairq";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CorantGmbH";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9OO3ox6q08QQcYfz4ArsKy/6jR329bAQPUo+mVYuhJs=";
  };

  propagatedBuildInputs = [
    aiohttp
    pycryptodome
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioairq"
  ];

  meta = with lib; {
    description = "Library to retrieve data from air-Q devices";
    homepage = "https://github.com/CorantGmbH/aioairq";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
