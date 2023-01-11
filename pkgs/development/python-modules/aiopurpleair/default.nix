{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopurpleair";
  version = "2022.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-YmJH4brWkTpgzyHwu9UnIWrY5qlDCmMtvF+KxQFXwfk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pydantic = "^1.10.2"' 'pydantic = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  checkInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [
    "aiopurpleair"
  ];

  meta = with lib; {
    description = "Python library for interacting with the PurpleAir API";
    homepage = "https://github.com/bachya/aiopurpleair";
    changelog = "https://github.com/bachya/aiopurpleair/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
