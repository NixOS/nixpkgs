{ lib, stdenv, fetchPypi, buildPythonPackage, libusb1, setuptools_scm }:

buildPythonPackage rec {
  pname = "pyusb";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d69ed64bff0e2102da11b3f49567256867853b861178689671a163d30865c298";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  # Fix the USB backend library lookup
  postPatch =
    ''
      libusb=${libusb1.out}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}
      test -f $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
      sed -i -e "s|find_library=None|find_library=lambda _:\"$libusb\"|" usb/backend/libusb1.py
    '';

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "usb" ];

  meta = with lib; {
    description = "Python USB access module (wraps libusb 1.0)";  # can use other backends
    homepage = "https://pyusb.github.io/pyusb/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
  };
}
