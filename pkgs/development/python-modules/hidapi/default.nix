{ stdenv, libusb1, udev, darwin, fetchPypi, buildPythonPackage, cython }:

buildPythonPackage rec {
  pname = "hidapi";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2560ad8db212f54cf40ea8d78715adad7df803011cfdce9dabbac0e76acf31ef";
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
