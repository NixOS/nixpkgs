{ lib
, aiofiles
, aiohttp
, async-generator
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pypubsub
, pyserial
, pyserial-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, voluptuous
, wheel
}:

buildPythonPackage rec {
  pname = "pyinsteon";
  version = "1.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-REm0E7+otqDypVslB5heHEaWA+q3Nh1O96gxFeCC3As=";
  };

  patches = [
    # https://github.com/pyinsteon/pyinsteon/pull/361
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/pyinsteon/pyinsteon/commit/676bc5fff11b73a4c3fd189a6ac6d3de9ca21ae0.patch";
      hash = "sha256-kTu1+IwDrcdqelyK/vfhxw8MQBis5I1jag7YTytKQhs=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
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
    async-generator
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
    changelog = "https://github.com/pyinsteon/pyinsteon/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
