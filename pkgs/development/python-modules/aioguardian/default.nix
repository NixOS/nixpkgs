{ lib
, aiohttp
, async-timeout
, asyncio-dgram
, asynctest
, buildPythonPackage
, cryptography
, fetchFromGitHub
, poetry
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonAtLeast
, voluptuous
}:

buildPythonPackage rec {
  pname = "aioguardian";
  version = "1.0.4";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "1cbxcsxh9c8r2zx3lsjdns26sm2qmlwnqgah2sfzbgp1lay23vvq";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    asyncio-dgram
    voluptuous
  ];

  checkInputs = [
    asyncio-dgram
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  # Ignore the examples as they are prefixed with test_
  pytestFlagsArray = [ "--ignore examples/" ];
  pythonImportsCheck = [ "aioguardian" ];

  meta = with lib; {
    description = " Python library to interact with Elexa Guardian devices";
    longDescription = ''
      aioguardian is a Pytho3, asyncio-focused library for interacting with the
      Guardian line of water valves and sensors from Elexa.
    '';
    homepage = "https://github.com/bachya/aioguardian";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
