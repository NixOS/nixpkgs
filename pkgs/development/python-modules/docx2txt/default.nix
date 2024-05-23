{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "docx2txt";
  version = "0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LAbZjXz+LTlH5XYKV9kk4/8HdFs3nIc3cjki5wCSNuU=";
  };

  pythonImportsCheck = [ "docx2txt" ];

  meta = with lib; {
    description = "A pure python-based utility to extract text and images from docx files";
    mainProgram = "docx2txt";
    homepage = "https://github.com/ankushshah89/python-docx2txt";
    license = licenses.mit;
    maintainers = with maintainers; [ ilkecan ];
  };
}
