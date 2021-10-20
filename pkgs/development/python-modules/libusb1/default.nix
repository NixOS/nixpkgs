{ lib, stdenv, buildPythonPackage, fetchPypi, libusb1, pytest }:

buildPythonPackage rec {
  pname = "libusb1";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3ba82ecf7ab6a48d21dac6697e26504670cc3522b8e5941bd28fb56cf3f6c46";
  };

  postPatch = ''
    substituteInPlace usb1/_libusb1.py --replace \
      "ctypes.util.find_library(base_name)" \
      "'${libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  buildInputs = [ libusb1 ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test usb1/testUSB1.py
  '';

  meta = with lib; {
    homepage    = "https://github.com/vpelletier/python-libusb1";
    description = "Python ctype-based wrapper around libusb1";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ prusnak rnhmjoj ];
  };
}
