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
    hash = "sha256-O4QKaxGEtfFWhjWxrasoFHlHUicH1BzroC1e0KCHcnk=";
  };

  meta = with lib; {
    homepage = "https://github.com/chipsalliance/fasm/";
    description = "FPGA Assembly (FASM) Parser and Generator";
    license = licenses.asl20;
    maintainers = with maintainers; [ hansfbaier ];
  };
}
