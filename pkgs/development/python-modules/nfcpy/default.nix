{ lib
, buildPythonPackage
, libusb1
, ndeflib
, pydes
, pyserial
, pythonOlder
, fetchPypi
}:

buildPythonPackage rec {
  pname = "nfcpy";
  version = "1.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5b0I0BGeHZ6V0FIV+Diwe0TQO2Ua3dxSPMGjiJK4r2s=";
  };

  propagatedBuildInputs = [
    libusb1
    ndeflib
    pydes
    pyserial
  ];

  doCheck = false;

  pythonImportsCheck = [
    "nfc"
  ];

  meta = with lib; {
    description = "Python module for Near Field Communication";
    homepage = "https://github.com/nfcpy/nfcpy";
    license = licenses.eupl11;
    maintainers = with maintainers; [ RaghavSood ];
  };
}
