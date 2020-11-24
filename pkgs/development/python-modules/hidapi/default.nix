{ stdenv, libusb1, udev, darwin, fetchPypi, buildPythonPackage, cython }:

buildPythonPackage rec {
  pname = "hidapi";
  version = "0.10.0.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27c04d42a7187becf7a8309d4846aa4f235ac8b7dafd758335b109f5cbd3b962";
  };

  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isLinux [ libusb1 udev ] ++
    stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit CoreFoundation IOKit ]) ++
    [ cython ];

  # Fix the USB backend library lookup
  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    libusb=${libusb1.dev}/include/libusb-1.0
    test -d $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|/usr/include/libusb-1.0|$libusb|" setup.py
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace 'macos_sdk_path =' 'macos_sdk_path = "" #'
  '';

  pythonImportsCheck = [ "hid" ];

  meta = with stdenv.lib; {
    description = "A Cython interface to the hidapi from https://github.com/libusb/hidapi";
    homepage = "https://github.com/trezor/cython-hidapi";
    # license can actually be either bsd3 or gpl3
    # see https://github.com/trezor/cython-hidapi/blob/master/LICENSE-orig.txt
    license = licenses.bsd3;
    maintainers = with maintainers; [ np prusnak ];
  };
}
