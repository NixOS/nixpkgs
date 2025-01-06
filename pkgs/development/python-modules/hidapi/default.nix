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
  version = "0.14.0.post2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bA6XumsFmjCdUbSVqPDV77zqh1a2QNmLb2u5/e8kWKw=";
  };

  nativeBuildInputs = [ cython_0 ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  propagatedBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libusb1
      udev
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        CoreFoundation
        IOKit
      ]
    );

  # Fix the USB backend library lookup
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
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
