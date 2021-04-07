{ lib, buildPythonPackage, fetchPypi, pypdf2 }:

buildPythonPackage rec {
  pname = "pdftools.pdfposter";
  version = "0.7.post1";

  propagatedBuildInputs = [ pypdf2 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c1avpbr9q53yzq5ar2x485rmp9d0l3z27aham32bg7gplzd7w0j";
  };

  meta = with lib; {
    description = "Split large pages of a PDF into smaller ones for poster printing";
    homepage = "https://pdfposter.readthedocs.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wamserma ];
  };
}
