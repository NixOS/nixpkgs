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
  version = "0.1.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gGr9yzcEgcte2uYhHzgmqT80JRJyRia31bK/v+42teU=";
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

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "renault_api" ];

  meta = with lib; {
    description = "Python library to interact with the Renault API";
    homepage = "https://github.com/hacf-fr/renault-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
