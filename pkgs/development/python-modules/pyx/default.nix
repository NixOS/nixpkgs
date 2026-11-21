{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "pyx";
  version = "0.18";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lm2mtRhuBv04ScIQ2uksiOEgJ5wLvs/gO9o/dj6S18w=";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python package for the generation of PostScript, PDF, and SVG files";
    homepage = "https://pyx.sourceforge.net/";
    license = lib.licenses.gpl2;
  };
}
