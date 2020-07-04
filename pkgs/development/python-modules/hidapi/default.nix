{ stdenv, libusb1, udev, darwin, fetchPypi, buildPythonPackage, cython }:

buildPythonPackage rec {
  pname = "hidapi";
  version = "0.9.0.post2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a71dd3c153cb6bb2b73d2612b5ab262830d78c6428f33f0c06818749e64c9320";
  };

  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isLinux [ libusb1 udev ] ++
    stdenv.lib.optionals stdenv.isDarwin [ darwin.IOKit darwin.apple_sdk.frameworks.CoreFoundation ] ++
    [ cython ];

  # Fix the USB backend library lookup
  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    libusb=${libusb1.dev}/include/libusb-1.0
    test -d $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|/usr/include/libusb-1.0|$libusb|" setup.py
  '';

  meta = with stdenv.lib; {
    description = "A Cython interface to the hidapi from https://github.com/signal11/hidapi";
    homepage = "https://github.com/trezor/cython-hidapi";
    # license can actually be either bsd3 or gpl3
    # see https://github.com/trezor/cython-hidapi/blob/master/LICENSE-orig.txt
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
