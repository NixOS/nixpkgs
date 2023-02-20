{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytest-aiohttp
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyairnow";
  version = "1.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asymworks";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-aab+3xrEiCjysa+DzXWelQwz8V2tr74y8v0NpDZiuTk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyairnow"
  ];

  meta = with lib; {
    description = "Python wrapper for EPA AirNow Air Quality API";
    homepage = "https://github.com/asymworks/pyairnow";
    changelog = "https://github.com/asymworks/pyairnow/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
