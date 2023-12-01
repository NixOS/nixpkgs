{ lib
, aiohttp
, async-timeout
, asyncio-dgram
, buildPythonPackage
, docutils
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "aioguardian";
  version = "2023.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioguardian";
    rev = "refs/tags/${version}";
    hash = "sha256-hTV6P9J7SS5lnV/9eFUCFPZu1GIeshytWQvNTbGs52w=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    asyncio-dgram
    docutils
    voluptuous
  ];

  nativeCheckInputs = [
    asyncio-dgram
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    "examples/"
  ];

  pythonImportsCheck = [
    "aioguardian"
  ];

  meta = with lib; {
    description = " Python library to interact with Elexa Guardian devices";
    longDescription = ''
      aioguardian is an asyncio-focused library for interacting with the
      Guardian line of water valves and sensors from Elexa.
    '';
    homepage = "https://github.com/bachya/aioguardian";
    changelog = "https://github.com/bachya/aioguardian/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
