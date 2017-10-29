{ stdenv, fetchurl, buildPythonPackage, libusb, libusb1 }:

buildPythonPackage rec {
  name = "pyusb-1.0.0";

  src = fetchurl {
    url = "https://pypi.python.org/packages/8a/19/66fb48a4905e472f5dfeda3a1bafac369fbf6d6fc5cf55b780864962652d/PyUSB-1.0.0.tar.gz";
    sha256 = "0s2k4z06fapd5vp1gnrlf8a9sjpc03p9974lzw5k6ky39akzyd2v";
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
