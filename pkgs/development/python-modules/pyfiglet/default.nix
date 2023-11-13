{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-x9kIim+CG99pxY2XVzeAhadogWJrIwjmu9pwcSFgfxg=";
  };

  doCheck = false;

  meta = with lib; {
    description = "FIGlet in pure Python";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
