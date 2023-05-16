{ lib
, adb-shell
, aiofiles
<<<<<<< HEAD
, async-timeout
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, fetchFromGitHub
, mock
, pure-python-adb
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "androidtv";
<<<<<<< HEAD
  version = "0.0.72";
=======
  version = "0.0.70";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "python-androidtv";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oDC5NWmdo6Ijxz2ER9CjtCZxWkancUNyxVe2ofH4c+Q=";
=======
    hash = "sha256-LKV5aO3sptHz48UYpP+zPk6pPhyHAZWAxiTTIWKHiSg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    adb-shell
<<<<<<< HEAD
    async-timeout
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pure-python-adb
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
    inherit (adb-shell.optional-dependencies) usb;
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.async
  ++ passthru.optional-dependencies.usb;

  disabledTests = [
    # Requires git but fails anyway
    "test_no_underscores"
  ];

  pythonImportsCheck = [
    "androidtv"
  ];

  meta = with lib; {
    description = "Communicate with an Android TV or Fire TV device via ADB over a network";
    homepage = "https://github.com/JeffLIrion/python-androidtv/";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
