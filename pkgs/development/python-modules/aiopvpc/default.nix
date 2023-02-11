{ lib
, aiohttp
, async-timeout
, backports-zoneinfo
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, python-dotenv
}:

buildPythonPackage rec {
  pname = "aiopvpc";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "azogue";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-E5z74/5VuFuOyAfeT4PQlHUNOiVT4sPgOdxoAIIymxU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      " --cov --cov-report term --cov-report html" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [
    "aiopvpc"
  ];

  meta = with lib; {
    description = "Python module to download Spanish electricity hourly prices (PVPC)";
    homepage = "https://github.com/azogue/aiopvpc";
    changelog = "https://github.com/azogue/aiopvpc/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
