{ stdenv, fetchPypi, buildPythonPackage, libusb, libusb1 }:

buildPythonPackage rec {
  pname = "pyusb";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qkk2jn270jwwl1x26hmdhb14m9kkbrzzwzizdjcl1a29b6756sf";
  };

  # Fix the USB backend library lookup
  postPatch =
    ''
      libusb=${libusb1.out}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}
      test -f $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
      sed -i -e "s|find_library=None|find_library=lambda _:\"$libusb\"|" usb/backend/libusb1.py
    '';

  propagatedBuildInputs = [ libusb ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python USB access module (wraps libusb 1.0)";  # can use other backends
    homepage = http://pyusb.sourceforge.net/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
  };
}
