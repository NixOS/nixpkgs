{
  lib,
  buildPythonPackage,
  fetchPypi,
  libftdi1,
  libusb1,
  pythonOlder,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pylibftdi";
  version = "0.23.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v1tMa6c9eab234ScNFsAunY9AjIBvtm6Udh2pDl7Ftg=";
  };

  build-system = [ poetry-core ];

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

  meta = with lib; {
    description = "Wrapper to Intra2net's libftdi driver for FTDI's USB devices";
    homepage = "https://pylibftdi.readthedocs.io/";
    changelog = "https://github.com/codedstructure/pylibftdi/blob/${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
