{ lib, buildPythonPackage, fetchPypi, fire, tqdm, intelhex, libusb1 }:

buildPythonPackage rec {
  pname = "nkdfu";
  version = "0.1";
  format = "flit";

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

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "nkdfu" ];

  meta = with lib; {
    description = "Python tool for Nitrokeys' firmware update";
    homepage = "https://github.com/Nitrokey/nkdfu";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ frogamic ];
  };
}
