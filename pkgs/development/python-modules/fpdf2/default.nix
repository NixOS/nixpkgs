{ lib
, buildPythonPackage
, fetchPypi
, defusedxml
, pillow
, fonttools
}:

buildPythonPackage rec {
  pname = "fpdf2";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O7GfowpbHXb9FHCkdGTeXgqkzBynKWE/3RB2gXrv/kM=";
  };

  propagatedBuildInputs = [ defusedxml pillow fonttools ];

  doCheck = false;

  pythonImportsCheck = [ "fpdf" ];

  meta = with lib; {
    description = "PDF creation library for Python";
    license = licenses.lgpl3Plus;
    homepage = "https://pyfpdf.github.io/fpdf2/";
    maintainers = with maintainers; [ carpinchomug ];
  };
}
