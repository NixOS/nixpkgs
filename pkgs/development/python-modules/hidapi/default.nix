{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  xcbuild,
  cython_0,
  libusb1,
  udev,
  darwin,
}:

buildPythonPackage rec {
  pname = "hidapi";
  version = "0.14.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p8sCkobO1UJqOBKGUm2VAYRkCXAaKcJThhXD0aYSuL4=";
  };

  nativeBuildInputs = [ cython_0 ] ++ lib.optionals stdenv.isDarwin [ xcbuild ];

  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [
      libusb1
      udev
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        CoreFoundation
        IOKit
      ]
    );

  # Fix the USB backend library lookup
  postPatch = lib.optionalString stdenv.isLinux ''
    libusb=${libusb1.dev}/include/libusb-1.0
    test -d $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|/usr/include/libusb-1.0|$libusb|" setup.py
  '';

  pythonImportsCheck = [ "hid" ];

  meta = with lib; {
    description = "Cython interface to the hidapi from https://github.com/libusb/hidapi";
    homepage = "https://github.com/trezor/cython-hidapi";
    # license can actually be either bsd3 or gpl3
    # see https://github.com/trezor/cython-hidapi/blob/master/LICENSE-orig.txt
    license = with licenses; [
      bsd3
      gpl3Only
    ];
    maintainers = with maintainers; [
      np
      prusnak
    ];
  };
}
