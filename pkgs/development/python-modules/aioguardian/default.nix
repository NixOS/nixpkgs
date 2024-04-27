{ lib
, aiohttp
, async-timeout
, asyncio-dgram
, buildPythonPackage
, certifi
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
  version = "2023.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioguardian";
    rev = "refs/tags/${version}";
    hash = "sha256-7fY8+aAxlDtOBLu8SadY5qiH6+RvxnFpOw1RXTonP2o=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    asyncio-dgram
    certifi
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
