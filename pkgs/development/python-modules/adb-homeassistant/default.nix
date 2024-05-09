{ lib
, buildPythonPackage
, fetchFromGitHub
, libusb1
, rsa
, pycryptodome
, pytest
, mock
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
    sha256 = "0s3fazvbzchn1fsvjrd1jl8w9y4dvvgq6q8m8p5lr2gri0npr581";

  };

  propagatedBuildInputs = [
    libusb1
    rsa
    pycryptodome
  ];

  nativeCheckInputs = [ pytest mock ];
  checkPhase = ''
    py.test test
  '';

  meta = with lib; {
    description = "A pure python implementation of the Android ADB and Fastboot protocols";
    homepage = "https://github.com/JeffLIrion/python-adb/tree/adb-homeassistant";
    license = licenses.asl20;
    maintainers = [ maintainers.makefu ];
  };
}
