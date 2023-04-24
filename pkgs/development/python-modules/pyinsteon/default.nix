{ lib
, aiofiles
, aiohttp
, async_generator
, buildPythonPackage
, fetchFromGitHub
, pypubsub
, pyserial
, pyserial-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, voluptuous
}:

buildPythonPackage rec {
  pname = "pyinsteon";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5c2hcW9XSEyIMlyrn70U7tgBWdxGrtJoQkjkYzlrbKE=";
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
    voluptuous
  ];

  nativeCheckInputs = [
    async_generator
    pytestCheckHook
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
