{ buildPythonPackage, pytest, lib, fetchPypi }:

buildPythonPackage rec {
  pname = "affine";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ok2BjWqDbBMZdtIvjCe408oy0K9kwdjSnet7r6TaHuo=";
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
