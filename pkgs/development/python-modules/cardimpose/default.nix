{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pymupdf,
}:
buildPythonPackage (finalAttrs: {
  pname = "cardimpose";
  version = "0.2.2";
  pyproject = true;

  __structuredAttrs = true;

  # Get source from Pypi as the GitHub repository doesn't have any version
  # indicators, so there's no way to tell when a new version is available or
  # what the version should be.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fMI2bvsHGYU7nZ9CdaUtWQkNj2MihMEcBCVy8VbE6F0=";
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
})
