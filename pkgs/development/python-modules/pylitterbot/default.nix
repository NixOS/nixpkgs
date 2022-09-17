{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyjwt
, pytest-aiohttp
, pytest-freezegun
, pytestCheckHook
, pythonOlder
, deepdiff
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2022.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iGif349AhrqcJnaZZdGc7x4KD7u4oStmKWxIY/knMww=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    deepdiff
    pyjwt
  ];

  checkInputs = [
    aioresponses
    pytest-aiohttp
    pytest-freezegun
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  pythonImportsCheck = [
    "pylitterbot"
  ];

  meta = with lib; {
    description = "Modulefor controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
