{ lib, stdenv, fetchPypi, buildPythonPackage, libusb1, setuptools-scm }:

buildPythonPackage rec {
  pname = "pyusb";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d449ad916ce58aff60b89aae0b65ac130f289c24d6a5b7b317742eccffafc38";
  };

  nativeBuildInputs = [
    setuptools-scm
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
