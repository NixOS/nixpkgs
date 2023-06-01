{ lib, buildPythonPackage, fetchPypi, pypdf2 }:

buildPythonPackage rec {
  pname = "pdftools.pdfposter";
  version = "0.8.1";
  format = "setuptools";

  propagatedBuildInputs = [ pypdf2 ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yWFtHgVKAWs4dRlSk8t8cB2KBJeBOa0Frh3BLR9txS0=";
  };

  pythonImportsCheck = [
    "pdftools.pdfposter"
    "pdftools.pdfposter.cmd"
  ];

  meta = with lib; {
    description = "Split large pages of a PDF into smaller ones for poster printing";
    homepage = "https://pdfposter.readthedocs.io";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wamserma ];
  };
}
