{ lib, buildPythonPackage, fetchPypi, pypdf2 }:

buildPythonPackage rec {
  pname = "pdftools.pdfposter";
  version = "0.8";

  propagatedBuildInputs = [ pypdf2 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SYEn54kpO6KQ8ywpgu0+3uL+Ilr1hsfSornWrs2EBqQ=";
  };

  meta = with lib; {
    description = "Split large pages of a PDF into smaller ones for poster printing";
    homepage = "https://pdfposter.readthedocs.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wamserma ];
  };
}
