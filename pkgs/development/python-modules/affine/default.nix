{ buildPythonPackage, pytest, lib, fetchPypi }:

buildPythonPackage rec {
  pname = "affine";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1nbeZhV61q+Z/9lOD1Tonfw1sPtyUurS7QrS3KQxvdA=";
  };

  nativeCheckInputs = [ pytest ];
  checkPhase = "py.test";

  meta = with lib; {
    description = "Matrices describing affine transformation of the plane";
    license = licenses.bsd3;
    homepage = "https://github.com/sgillies/affine";
    maintainers = with maintainers; [ mredaelli ];
  };

}
