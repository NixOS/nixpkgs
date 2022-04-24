{ lib
, aiofiles
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
  version = "0.4.2";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "adb_shell";
    rev = "v${version}";
    hash = "sha256-8tclSjmLlTAIeq6t7YPGtJwvSwtlzQ7sRAQatcQRzeY=";
  };

  propagatedBuildInputs = [
    cryptography
    pyasn1
    rsa
  ];

  passthru.extras-require = {
    async = [
      aiofiles
    ];
    usb = [
      libusb1
    ];
  };

  checkInputs = [
    mock
    pycryptodome
    pytestCheckHook
  ]
  ++ passthru.extras-require.async
  ++ passthru.extras-require.usb;

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # Tests are failing with Python 3.10
    # https://github.com/JeffLIrion/adb_shell/issues/198
    "TestAdbDeviceAsync"
    "TestTcpTransportAsync"
  ];

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
