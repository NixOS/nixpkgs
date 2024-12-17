{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pymupdf,
}:
buildPythonPackage rec {
  pname = "cardimpose";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7GyLTUzWd9cZ8/k+0FfzKW3H2rKZ3NHqkZkNmiQ+Tec=";
  };

  build-system = [ setuptools ];

  dependencies = [ pymupdf ];

  pythonImportsCheck = [ "cardimpose" ];

  meta = {
    mainProgram = "cardimpose";
    description = "Library for imposing PDF files";
    longDescription = ''
      Cardimpose is a Python library that makes it easy to arrange multiple
      copies of a PDF on a larger document, perfect for scenarios like printing
      business cards. The library lets you customize your layout while adding
      crop marks and comes with a handy command line tool.
    '';
    homepage = "https://github.com/frsche/cardimpose";
    license = lib.licenses.agpl3Only;
    platforms = pymupdf.meta.platforms;
    badPlatforms = pymupdf.meta.badPlatforms or [ ];
    maintainers = [ lib.maintainers.me-and ];
  };
}
