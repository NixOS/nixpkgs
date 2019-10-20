{ buildPythonPackage, pytest, lib, fetchPypi }:

buildPythonPackage rec {
  pname = "affine";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00jil4q3b17qml6azim7s7zar6qb1vhsf0g888y637m23bpms11f";
  };

  checkInputs = [ pytest ];
  checkPhase = "py.test";

  meta = with lib; {
    description = "Matrices describing affine transformation of the plane";
    license = licenses.bsd3;
    homepage = https://github.com/sgillies/affine;
    maintainers = with maintainers; [ mredaelli ];
  };

}
