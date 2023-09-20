{ lib
, buildPythonPackage
, fetchPypi
, libftdi1
, libusb1
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylibftdi";
  version = "0.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-634vUFKFJUf0xsRgIqFmX510U0OWORcereVv3ICliDI=";
  };

  propagatedBuildInputs = [
    libftdi1
    libusb1
  ];

  postPatch = ''
    substituteInPlace src/pylibftdi/driver.py \
      --replace "self._load_library('libusb')" "cdll.LoadLibrary('${libusb1.out}/lib/libusb-1.0.so')" \
      --replace "self._load_library('libftdi')" "cdll.LoadLibrary('${libftdi1.out}/lib/libftdi1.so')"
  '';

  pythonImportsCheck = [
    "pylibftdi"
  ];

  meta = with lib; {
    description = "Wrapper to Intra2net's libftdi driver for FTDI's USB devices";
    homepage = "https://pylibftdi.readthedocs.io/";
    changelog = "https://github.com/codedstructure/pylibftdi/blob/${version}0/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
