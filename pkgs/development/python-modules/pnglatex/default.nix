{
  lib,
  buildPythonPackage,
  fetchPypi,
  poppler_utils,
  netpbm,
}:

buildPythonPackage rec {

  pname = "pnglatex";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CZUGDUkmttO0BzFYbGFSNMPkWzFC/BW4NmAeOwz4Y9M=";
  };

  propagatedBuildInputs = [
    poppler_utils
    netpbm
  ];

  # There are no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/MaT1g3R/pnglatex";
    description = "Small program that converts LaTeX snippets to png";
    mainProgram = "pnglatex";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
