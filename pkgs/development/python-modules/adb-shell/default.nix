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
  version = "0.4.3";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "adb_shell";
    rev = "v${version}";
    hash = "sha256-+RU3nyJpHq0r/9erEbjUILpwIPWq14HdOX7LkSxySs4=";
  };

  propagatedBuildInputs = [
    cryptography
    pyasn1
    rsa
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
    usb = [
      libusb1
    ];
  };

  nativeCheckInputs = [
    mock
    pycryptodome
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.async
  ++ passthru.optional-dependencies.usb;

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
