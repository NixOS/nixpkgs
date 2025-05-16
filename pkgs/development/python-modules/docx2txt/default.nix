{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "docx2txt";
  version = "0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GAE/YimxSQkCixmqe/T489bkYy17CJqyn38KTR9mDig=";
  };

  pythonImportsCheck = [ "docx2txt" ];

  meta = with lib; {
    description = "Pure python-based utility to extract text and images from docx files";
    mainProgram = "docx2txt";
    homepage = "https://github.com/ankushshah89/python-docx2txt";
    license = licenses.mit;
    maintainers = with maintainers; [ ilkecan ];
  };
}
