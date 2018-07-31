{ stdenv, lib, buildPythonPackage, fetchPypi, python, libusb1 }:

buildPythonPackage rec {
  pname = "libusb1";
  version = "1.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4707f81e933a97fed1c5bf7d4957f07bae1139cb8084bdee1f50201a40e3fd7c";
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
