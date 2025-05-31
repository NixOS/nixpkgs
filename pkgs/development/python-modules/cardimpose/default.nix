{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pymupdf,
}:
buildPythonPackage {
  pname = "cardimpose";
  version = "0.2.1-unstable-2024-12-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frsche";
    repo = "cardimpose";
    rev = "eb26a9795e20db3e3dd5b62dbcbbad547cb05a55";
    hash = "sha256-Fel0YOe2D76h+QAon/wxI6EsZhfLca+0ncNi9i888+E=";
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
