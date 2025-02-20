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
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vpelletier";
    repo = "python-libusb1";
    tag = version;
    hash = "sha256-D2VMqrq1MQa6gp8vxDiLRAqTDyRGK3qVKo6YMmo5Zrg=";
  };

  patches = [
    (replaceVars ./ctypes.patch {
      libusb = "${lib.getLib libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  buildInputs = [ libusb1 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "usb1/testUSB1.py" ];

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
