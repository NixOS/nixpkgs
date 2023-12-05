{ lib, buildPythonPackage, fetchPypi, flit-core, fire, tqdm, intelhex, libusb1 }:

buildPythonPackage rec {
  pname = "nkdfu";
  version = "0.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8l913dOCxHKFtpQ83p9RV3sUlu0oT5PVi14FSuYJ9fg=";
  };

  nativeBuildInputs = [
    flit-core
  ];

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
