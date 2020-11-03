{ lib
, buildPythonPackage
, fetchPypi
, libftdi1
, libusb1
}:

buildPythonPackage rec {
  pname = "pylibftdi";
  version = "0.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb0ec74df292ef884aa37bf1e98fb9df4d338718e1559eebda363317a792123e";
  };

  requiredPythonModules = [
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
