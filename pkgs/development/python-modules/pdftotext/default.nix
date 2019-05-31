{ lib, buildPythonPackage, fetchPypi, poppler }:

buildPythonPackage rec {
  pname = "pdftotext";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jwc2zpss0983wqqi0kpichasljsxar9c4ma8vycn8maw3pi3bg3";
  };

  buildInputs = [ poppler ];

  meta = with lib; {
    description = "Simple PDF text extraction";
    homepage = https://github.com/jalan/pdftotext;
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
