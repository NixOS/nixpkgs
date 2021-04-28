{ lib
, aiohttp
, async-timeout
, asyncio-dgram
, asynctest
, buildPythonPackage
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
  version = "1.0.7";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-KMhq86hcqoYloS/6VHsl+3KVEZBbN97ABrZlmEr32Z8=";
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
