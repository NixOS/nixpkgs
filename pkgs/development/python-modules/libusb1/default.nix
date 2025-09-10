{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  setuptools,
  libusb1,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libusb1";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vpelletier";
    repo = "python-libusb1";
    tag = version;
    hash = "sha256-nytxew6KogpEpSnRtmY0UNH+07x0k0XLZ/MRC9NSpDg=";
  };

  patches = [
    (replaceVars ./ctypes.patch {
      libusb = "${lib.getLib libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  buildInputs = [ libusb1 ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "usb1/testUSB1.py" ];

  meta = with lib; {
    homepage = "https://github.com/vpelletier/python-libusb1";
    description = "Python ctype-based wrapper around libusb1";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      prusnak
      rnhmjoj
    ];
  };
}
