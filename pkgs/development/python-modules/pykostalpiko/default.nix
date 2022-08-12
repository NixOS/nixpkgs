{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pykostalpiko";
  version = "1.1.1-1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Florian7843";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0szkxR19iSWWpPAEo3wriMmI5TFI6YeYRTj86b4rKlU=";
  };

  propagatedBuildInputs = [
    aiohttp
    click
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pykostalpiko"
  ];

  meta = with lib; {
    description = "Library and CLI-tool to fetch the data from a Kostal Piko inverter";
    homepage = "https://github.com/Florian7843/pykostalpiko";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
