{ buildPythonPackage, pytest, lib, fetchPypi }:

buildPythonPackage rec {
  pname = "affine";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j3mvcnmgjvvm0znqyf7xylq7i89zjf4dq0g8280xs6bwbl5cvih";
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
