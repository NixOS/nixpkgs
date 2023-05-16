{ lib
, aiofiles
<<<<<<< HEAD
, async-timeout
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, cryptography
, fetchFromGitHub
, isPy3k
, libusb1
, mock
, pyasn1
, pythonAtLeast
, pycryptodome
, pytestCheckHook
, rsa
}:

buildPythonPackage rec {
  pname = "adb-shell";
<<<<<<< HEAD
  version = "0.4.4";
=======
  version = "0.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "adb_shell";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pOkFUh3SEu/ch9R1lVoQn50nufQp8oI+D4/+Ybal5CA=";
=======
    hash = "sha256-+RU3nyJpHq0r/9erEbjUILpwIPWq14HdOX7LkSxySs4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cryptography
    pyasn1
    rsa
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
<<<<<<< HEAD
      async-timeout
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
    usb = [
      libusb1
    ];
  };

  nativeCheckInputs = [
    mock
    pycryptodome
    pytestCheckHook
<<<<<<< HEAD
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);
=======
  ]
  ++ passthru.optional-dependencies.async
  ++ passthru.optional-dependencies.usb;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "adb_shell"
  ];

  meta = with lib; {
    description = "Python implementation of ADB with shell and FileSync functionality";
    homepage = "https://github.com/JeffLIrion/adb_shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
