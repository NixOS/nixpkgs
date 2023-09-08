{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "fasm";
  version = "0.0.2.post100";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b840a6b1184b5f1568635b1adab28147947522707d41ceba02d5ed0a0877279";
  };

  meta = with lib; {
    homepage = "https://github.com/chipsalliance/fasm/";
    description = "FPGA Assembly (FASM) Parser and Generator";
    license = licenses.asl20;
    maintainers = with maintainers; [ hansfbaier ];
  };
}
