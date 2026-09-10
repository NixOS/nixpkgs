{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "docx2txt";
  version = "0.9";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GAE/YimxSQkCixmqe/T489bkYy17CJqyn38KTR9mDig=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "docx2txt" ];

  meta = {
    description = "Pure python-based utility to extract text and images from docx files";
    mainProgram = "docx2txt";
    homepage = "https://github.com/ankushshah89/python-docx2txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilkecan ];
  };
})
