{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libusb1,
  rsa,
  pycryptodome,
  pytest,
  mock,
}:
buildPythonPackage {
  pname = "adb-homeassistant";
  version = "1.3.1";
  format = "setuptools";

  # pypi does not contain tests, using github sources instead
  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "python-adb";
    rev = "5949bf432307cbba7128e84d7bc6add7f054a078";
    hash = "sha256-AZV8LYj5iUzLRRVhg9/ejfjEEZWhZbm1Cxayv/ZXbmg=";
  };

  propagatedBuildInputs = [
    libusb1
    rsa
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest
    mock
  ];
  checkPhase = ''
    py.test test
  '';

  meta = {
    description = "Pure python implementation of the Android ADB and Fastboot protocols";
    homepage = "https://github.com/JeffLIrion/python-adb/tree/adb-homeassistant";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.makefu ];
  };
}
