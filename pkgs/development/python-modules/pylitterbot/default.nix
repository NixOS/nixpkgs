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
  version = "2022.10.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-E7rBRPtXa/E6jf75zULuGaiu2DHvq4hZjcwPwj/w9ww=";
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
