{
  lib,
  buildPythonPackage,
  fetchPypi,
  libftdi1,
  libusb1,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylibftdi";
  version = "0.25.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ARNh/dnv3FLY0/7aOnkXaD8TaOf7XFmtVQ79ZRmwP5k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    libftdi1
    libusb1
  ];

  postPatch = ''
    substituteInPlace src/pylibftdi/driver.py \
      --replace-fail 'self._load_library("libusb")' 'cdll.LoadLibrary("${libusb1.out}/lib/libusb-1.0.so")' \
      --replace-fail 'self._load_library("libftdi")' 'cdll.LoadLibrary("${libftdi1.out}/lib/libftdi1.so")'
  '';

  pythonImportsCheck = [ "pylibftdi" ];

  meta = {
    description = "Wrapper to Intra2net's libftdi driver for FTDI's USB devices";
    homepage = "https://pylibftdi.readthedocs.io/";
    changelog = "https://github.com/codedstructure/pylibftdi/blob/${version}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthuszagh ];
  };
}
