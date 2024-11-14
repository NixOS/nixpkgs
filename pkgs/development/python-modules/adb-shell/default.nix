{
  lib,
  aiofiles,
  async-timeout,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  isPy3k,
  libusb1,
  mock,
  pyasn1,
  pycryptodome,
  pytestCheckHook,
  rsa,
}:

buildPythonPackage rec {
  pname = "adb-shell";
  version = "0.4.4";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "adb_shell";
    rev = "v${version}";
    hash = "sha256-pOkFUh3SEu/ch9R1lVoQn50nufQp8oI+D4/+Ybal5CA=";
  };

  propagatedBuildInputs = [
    cryptography
    pyasn1
    rsa
  ];

  optional-dependencies = {
    async = [
      aiofiles
      async-timeout
    ];
    usb = [ libusb1 ];
  };

  nativeCheckInputs = [
    mock
    pycryptodome
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "adb_shell" ];

  meta = with lib; {
    description = "Python implementation of ADB with shell and FileSync functionality";
    homepage = "https://github.com/JeffLIrion/adb_shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
