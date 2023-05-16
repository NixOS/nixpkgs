{ lib
, buildPythonPackage
, fetchPypi
, libftdi1
, libusb1
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylibftdi";
<<<<<<< HEAD
  version = "0.21.0";
=======
  version = "0.20.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-634vUFKFJUf0xsRgIqFmX510U0OWORcereVv3ICliDI=";
=======
    sha256 = "f4a87fc4af2c9c7d42badd4192ca9b529f32c9d96fdc8daea7e29c509226df5f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    libftdi1
    libusb1
  ];

  postPatch = ''
<<<<<<< HEAD
    substituteInPlace src/pylibftdi/driver.py \
=======
    substituteInPlace pylibftdi/driver.py \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --replace "self._load_library('libusb')" "cdll.LoadLibrary('${libusb1.out}/lib/libusb-1.0.so')" \
      --replace "self._load_library('libftdi')" "cdll.LoadLibrary('${libftdi1.out}/lib/libftdi1.so')"
  '';

  pythonImportsCheck = [
    "pylibftdi"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Wrapper to Intra2net's libftdi driver for FTDI's USB devices";
    homepage = "https://pylibftdi.readthedocs.io/";
    changelog = "https://github.com/codedstructure/pylibftdi/blob/${version}0/CHANGES.txt";
=======
    homepage = "https://pylibftdi.readthedocs.io/";
    description = "Wrapper to Intra2net's libftdi driver for FTDI's USB devices";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
