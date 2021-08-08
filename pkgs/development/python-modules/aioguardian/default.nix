{ lib
, aiohttp
, async-timeout
, asyncio-dgram
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonAtLeast
, voluptuous
}:

buildPythonPackage rec {
  pname = "aioguardian";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "0nqsacg0yrsqr6qax4486ffk8r88ra5yixxd6r88jwscm2bmjg3p";
  };

  format = "pyproject";

  nativeBuildInputs = [
    poetry-core
  ];

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

  disabledTestPaths = [ "examples/" ];

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
