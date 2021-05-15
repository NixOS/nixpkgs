{ lib, pyserial, buildPythonPackage, fetchPypi  }:

buildPythonPackage rec {
  pname = "pyfirmata";
  version = "1.1.0";

  src = fetchPypi {
    inherit version;
    pname = "pyFirmata";
    sha256 = "cc180d1b30c85a2bbca62c15fef1b871db048cdcfa80959968356d97bd3ff08e";
  };

  propagatedBuildInputs = [ pyserial ];

  meta = with lib; {
    homepage = "https://github.com/tino/pyFirmata";
    description = "A Python interface for the Firmata protocol";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
