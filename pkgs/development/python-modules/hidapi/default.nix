{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, xcbuild
, cython
, libusb1
, udev
, darwin
}:

buildPythonPackage rec {
  pname = "hidapi";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99b18b28ec414ef9b604ddaed08182e486a400486f31ca56f61d537eed1d17cf";
  };

  nativeBuildInputs = lib.optionals stdenv.isDarwin [ xcbuild ];

  propagatedBuildInputs = [ cython ]
    ++ lib.optionals stdenv.isLinux [ libusb1 udev ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit CoreFoundation IOKit ]);

  # Fix the USB backend library lookup
  postPatch = lib.optionalString stdenv.isLinux ''
    libusb=${libusb1.dev}/include/libusb-1.0
    test -d $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|/usr/include/libusb-1.0|$libusb|" setup.py
  '';

  pythonImportsCheck = [ "hid" ];

  meta = with lib; {
    description = "A Cython interface to the hidapi from https://github.com/libusb/hidapi";
    homepage = "https://github.com/trezor/cython-hidapi";
    # license can actually be either bsd3 or gpl3
    # see https://github.com/trezor/cython-hidapi/blob/master/LICENSE-orig.txt
    license = with licenses; [ bsd3 gpl3Only ];
    maintainers = with maintainers; [ np prusnak ];
  };
}
