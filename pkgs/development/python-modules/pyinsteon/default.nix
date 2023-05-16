{ lib
, aiofiles
, aiohttp
<<<<<<< HEAD
, async-generator
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
=======
, async_generator
, buildPythonPackage
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pypubsub
, pyserial
, pyserial-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, voluptuous
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pyinsteon";
<<<<<<< HEAD
  version = "1.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
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
=======
    hash = "sha256-5c2hcW9XSEyIMlyrn70U7tgBWdxGrtJoQkjkYzlrbKE=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    async-generator
=======
    async_generator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/pyinsteon/pyinsteon/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
