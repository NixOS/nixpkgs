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
  version = "1.0.7";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-KMhq86hcqoYloS/6VHsl+3KVEZBbN97ABrZlmEr32Z8=";
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

  postPatch = ''
    # https://github.com/bachya/aioguardian/pull/66
    substituteInPlace pyproject.toml \
      --replace 'asyncio_dgram = "^1.0.1"' 'asyncio_dgram = "^2.0.0"'
    # https://github.com/bachya/aioguardian/pull/67
    substituteInPlace pyproject.toml \
      --replace "poetry>=0.12" "poetry-core"
  '';

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
