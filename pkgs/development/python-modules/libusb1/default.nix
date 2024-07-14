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
    hash = "sha256-TumwpV+L0LPqcBeukZpsH0Oa90LEpLBFQ8X9evibgow=";
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
