{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
}:

buildPythonPackage rec {
  version = "0.4";
  pname = "Safe";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ov2sn+ip3PArQ4IB1s4Le+ePhdxkktA+37ib4q30id4=";
  };

  buildInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/lepture/safe";
    license = licenses.bsd3;
    description = "Check password strength";
  };
}
