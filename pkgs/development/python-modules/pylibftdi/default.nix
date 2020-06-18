{ stdenv
, lib
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
    sha256 = "0ghjjakifcrnvbmrwmg1323k6kfzp67ykwbvld58ivwjy96wf3mv";
  };

  propagatedBuildInputs = [
    libftdi1
    libusb1
  ];

  postPatch = ''
    substituteInPlace pylibftdi/driver.py \
      --replace "self._load_library('libusb')" \
        "cdll.LoadLibrary('${libusb1.out}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}')" \
      --replace "self._load_library('libftdi')" \
        "cdll.LoadLibrary('${libftdi1.out}/lib/libftdi1${stdenv.hostPlatform.extensions.sharedLibrary}')"
  '';

  pythonImportsCheck = [ "pylibftdi" ];

  meta = with lib; {
    homepage = "https://github.com/codedstructure/pylibftdi";
    description = "Minimal pythonic wrapper to Intra2net's libftdi driver for FTDI's USB devices";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
