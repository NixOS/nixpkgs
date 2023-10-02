{ lib
, aiohttp
, async-timeout
, asyncio-dgram
, buildPythonPackage
, docutils
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "aioguardian";
  version = "2023.08.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/UNSAfAkOXPJQDWBZIe/AYIhx83kPCjGzZjn4oh+gfY=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/aioguardian/pull/288
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/aioguardian/commit/ffaad4b396645f599815010995fb71ca976e761e.patch";
      hash = "sha256-RLRbHmaR2A8MNc96WHx0L8ccyygoBUaOulAuRJkFuUM=";
    })
  ];

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
