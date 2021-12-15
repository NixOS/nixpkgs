{ lib, buildPythonPackage, fetchPypi, isPy27, fire, tqdm, intelhex, libusb1 }:

buildPythonPackage rec {
  pname = "nkdfu";
  version = "0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y8GonfCBi3BNMhZ99SN6/SDSa0+dbfPIMPoVzALwH5A=";
  };

  propagatedBuildInputs = [
    fire
    tqdm
    intelhex
    libusb1
  ];

  meta = with lib; {
    homepage = "https://github.com/Nitrokey/nkdfu";
    description = "DFU tool for updating Nitrokeys' firmware";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emgrav ];
  };
}
