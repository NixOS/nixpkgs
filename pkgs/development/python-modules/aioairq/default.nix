{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pycryptodome
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioairq";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CorantGmbH";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BvesFiXiVlgfaffWfNcP1K9XUOL2qU8F/sdvRKNcuS4=";
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
