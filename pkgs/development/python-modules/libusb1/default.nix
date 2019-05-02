{ stdenv, lib, buildPythonPackage, fetchPypi, python, libusb1, pytest }:

buildPythonPackage rec {
  pname = "libusb1";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03vylg5mdsxp2nyk8sm7yxmb470hcb92q263dfq8d6b9xp96ckwx";
  };

  postPatch = ''
    substituteInPlace usb1/libusb1.py --replace \
      "ctypes.util.find_library(base_name)" \
      "'${libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  buildInputs = [ libusb1 ];

  checkInputs = [ pytest ];

  checkPhase = ''
    # USBPollerThread is unreliable. Let's not test it.
    # See: https://github.com/vpelletier/python-libusb1/issues/16
    py.test -k 'not testUSBPollerThreadExit' usb1/testUSB1.py
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/vpelletier/python-libusb1;
    description = "Python ctype-based wrapper around libusb1";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
