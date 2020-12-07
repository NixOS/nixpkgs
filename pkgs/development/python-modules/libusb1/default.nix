{ stdenv, buildPythonPackage, fetchPypi, libusb1, pytest }:

buildPythonPackage rec {
  pname = "libusb1";
  version = "1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:0l7vj04xm0i5ikxjdqrr5939q7amh0hfp0fqifkcvyjv9fvhyz65";
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
    homepage    = "https://github.com/vpelletier/python-libusb1";
    description = "Python ctype-based wrapper around libusb1";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
