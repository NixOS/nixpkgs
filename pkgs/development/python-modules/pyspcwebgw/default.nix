{ lib
, aiohttp
, aioresponses
, asynccmd
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyspcwebgw";
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mbrrg";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gdIrbr25GXaX26B1f7u0NKbqqnAC2tmMFZspzW6I4HI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asynccmd
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [ "pyspcwebgw" ];

  meta = with lib; {
    description = "Python module for the SPC Web Gateway REST API";
    homepage = "https://github.com/mbrrg/pyspcwebgw";
    changelog = "https://github.com/pyspcwebgw/pyspcwebgw/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
