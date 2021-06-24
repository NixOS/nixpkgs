{ lib, stdenv, libusb1, udev, darwin, fetchPypi, buildPythonPackage, cython }:

buildPythonPackage rec {
  pname = "hidapi";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1170b18050bc57fae3840a51084e8252fd319c0fc6043d68c8501deb0e25846";
  };

  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ libusb1 udev ] ++
    lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit CoreFoundation IOKit ]) ++
    [ cython ];

  # Fix the USB backend library lookup
  postPatch = lib.optionalString stdenv.isLinux ''
    libusb=${libusb1.dev}/include/libusb-1.0
    test -d $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|/usr/include/libusb-1.0|$libusb|" setup.py
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace 'macos_sdk_path =' 'macos_sdk_path = "" #'
  '';

  pythonImportsCheck = [ "hid" ];

  meta = with lib; {
    description = "A Cython interface to the hidapi from https://github.com/libusb/hidapi";
    homepage = "https://github.com/trezor/cython-hidapi";
    # license can actually be either bsd3 or gpl3
    # see https://github.com/trezor/cython-hidapi/blob/master/LICENSE-orig.txt
    license = licenses.bsd3;
    maintainers = with maintainers; [ np prusnak ];
  };
}
