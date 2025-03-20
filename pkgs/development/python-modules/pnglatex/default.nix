{
  lib,
  buildPythonPackage,
  fetchPypi,
  poppler-utils,
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
    poppler-utils
    netpbm
  ];

  # There are no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/MaT1g3R/pnglatex";
    description = "Small program that converts LaTeX snippets to png";
    mainProgram = "pnglatex";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
