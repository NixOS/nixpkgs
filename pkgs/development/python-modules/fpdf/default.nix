{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "fpdf";
  version = "1.7.2";

  src = fetchFromGitHub {
     owner = "reingart";
     repo = "pyfpdf";
     rev = "1.7.2";
     sha256 = "19rl2x2mm4kg4sayk1j251wxmdnc8dbilxz4sfri13bnrcn5jw35";
  };

  # No tests available
  doCheck = false;

  meta = {
    homepage = "https://github.com/reingart/pyfpdf";
    description = "Simple PDF generation for Python";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
