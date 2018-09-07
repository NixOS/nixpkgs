{ stdenv, lib, buildPythonPackage, fetchPypi, python, libusb1 }:

buildPythonPackage rec {
  pname = "libusb1";
  version = "1.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a49917a2262cf7134396f6720c8be011f14aabfc5cdc53f880cc672c0f39d271";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace usb1/libusb1.py --replace \
      "ctypes.util.find_library(base_name)" \
      "'${libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  buildInputs = [ libusb1 ];

  checkPhase = ''
    ${python.interpreter} -m usb1.testUSB1
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/vpelletier/python-libusb1;
    description = "Python ctype-based wrapper around libusb1";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
