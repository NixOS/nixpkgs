{ lib, stdenv, buildPythonPackage, fetchPypi, libusb1, pytest }:

buildPythonPackage rec {
  pname = "libusb1";
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60e6ce37be064f6e51d02b25da44230ecc9c0b1fdb6f14568c71457d963c1749";
  };

  postPatch = ''
    substituteInPlace usb1/libusb1.py --replace \
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
