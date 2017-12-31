{ stdenv, lib, buildPythonPackage, fetchPypi, libusb1 }:

buildPythonPackage rec {
  pname = "libusb1";
  version = "1.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03b7xrz8vqg8w0za5r503jhcmbd1ls5610jcja1rqz833nf0v4wc";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace usb1/libusb1.py --replace \
      "ctypes.util.find_library(base_name)" \
      "'${libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  buildInputs = [ libusb1 ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/vpelletier/python-libusb1;
    description = "Python ctype-based wrapper around libusb1";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
