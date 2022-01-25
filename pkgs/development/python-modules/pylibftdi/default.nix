{ lib
, buildPythonPackage
, fetchPypi
, libftdi1
, libusb1
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylibftdi";
  version = "0.20.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4a87fc4af2c9c7d42badd4192ca9b529f32c9d96fdc8daea7e29c509226df5f";
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

  pythonImportsCheck = [
    "pylibftdi"
  ];

  meta = with lib; {
    homepage = "https://pylibftdi.readthedocs.io/";
    description = "Wrapper to Intra2net's libftdi driver for FTDI's USB devices";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
