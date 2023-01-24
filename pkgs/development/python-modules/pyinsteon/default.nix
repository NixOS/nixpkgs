{ lib
, aiofiles
, aiohttp
, async_generator
, buildPythonPackage
, fetchFromGitHub
, pypubsub
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
, voluptuous
}:

buildPythonPackage rec {
  pname = "pyinsteon";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-yxWogOcZV0ZvV0a61YF47nqei+LGwD/Xz4QqNeJQtFA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    pypubsub
    pyserial
    pyserial-asyncio
    pyyaml
    voluptuous
  ];

  nativeCheckInputs = [
    async_generator
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    "test_results"
  ];

  pythonImportsCheck = [
    "pyinsteon"
  ];

  meta = with lib; {
    description = "Python library to support Insteon home automation projects";
    longDescription = ''
      This is a Python package to interface with an Insteon Modem. It has been
      tested to work with most USB or RS-232 serial based devices such as the
      2413U, 2412S, 2448A7 and Hub models 2242 and 2245.
    '';
    homepage = "https://github.com/pyinsteon/pyinsteon";
    changelog = "https://github.com/pyinsteon/pyinsteon/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
