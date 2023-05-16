{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, click
, dateparser
, fetchFromGitHub
, marshmallow-dataclass
, poetry-core
, pyjwt
, pythonOlder
, pytest-asyncio
, pytestCheckHook
, tabulate
}:

buildPythonPackage rec {
  pname = "renault-api";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-x6+rFstZM7Uplwa8NeRBTb8FYSD/NGjN/3q5earvN7c=";
=======
    hash = "sha256-BpPow6fZGAk0kzcEo5tOleyVMNUOl7RE2I5y76ntNRM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    click
    dateparser
    marshmallow-dataclass
    pyjwt
    tabulate
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [
    "renault_api"
  ];

  meta = with lib; {
    description = "Python library to interact with the Renault API";
    homepage = "https://github.com/hacf-fr/renault-api";
    changelog = "https://github.com/hacf-fr/renault-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
