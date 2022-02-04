{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioaseko";
  version = "0.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dfU2J4aDKNR+GoEmdq/NhX4Mrmm9tmCkse1tb+V5EFQ=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioaseko"
  ];

  meta = with lib; {
    description = "Module to interact with the Aseko Pool Live API";
    homepage = "https://github.com/milanmeu/aioaseko";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
