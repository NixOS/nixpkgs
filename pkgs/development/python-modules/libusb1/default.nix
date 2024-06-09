{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  libusb1,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libusb1";
  version = "3.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ee9b0a55f8bd0b3ea7017ae919a6c1f439af742c4a4b04543c5fd7af89b828c";
  };

  postPatch = ''
    substituteInPlace usb1/_libusb1.py --replace \
      "ctypes.util.find_library(base_name)" \
      "'${libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

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
