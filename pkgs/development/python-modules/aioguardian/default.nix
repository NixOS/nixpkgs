{ lib
, aiohttp
, async-timeout
, asyncio-dgram
, asynctest
, buildPythonPackage
, docutils
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec {
  pname = "aioguardian";
  version = "2022.03.2";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-eEvvcj8tHNErU6RrWar5mxG3xbQ5wCEEYJ95hXkdY54=";
  };

  format = "pyproject";

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

  checkInputs = [
    asyncio-dgram
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'docutils = "<0.18"' 'docutils = "*"'
  '';

  disabledTestPaths = [
    "examples/"
  ];

  pythonImportsCheck = [
    "aioguardian"
  ];

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
