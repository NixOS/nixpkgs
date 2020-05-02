{ lib
, buildPythonPackage
, fetchPypi
, libftdi1
, libusb1
}:

buildPythonPackage rec {
  pname = "pylibftdi";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17c5h4xz1grynbpffngjflk3dlw2g2zbhkwb7h5v4n9rjdv41l5x";
  };

  propagatedBuildInputs = [
    libftdi1
    libusb1
  ];

  postPatch = ''
    substituteInPlace pylibftdi/driver.py \
      --replace "self._load_library('libusb')" "cdll.LoadLibrary('${libusb1.out}/lib/libusb-1.0.so')" \
      --replace "self._load_library('libftdi')" "cdll.LoadLibrary('${libftdi1.out}/lib/libftdi1.so')"
  '';

  pythonImportsCheck = [ "pylibftdi" ];

  meta = with lib; {
    homepage = "https://bitbucket.org/codedstructure/pylibftdi/src/default/";
    description = "Minimal pythonic wrapper to Intra2net's libftdi driver for FTDI's USB devices";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
