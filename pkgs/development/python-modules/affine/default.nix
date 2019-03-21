{ buildPythonPackage, pytest, lib, fetchPypi }:

buildPythonPackage rec {
  pname = "affine";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "146slzpj2b220dmbmrxib030wymvplawxzn7gcgnbahgm500y3gz";
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
