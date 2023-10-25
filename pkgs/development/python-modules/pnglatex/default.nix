{ lib, buildPythonPackage, fetchPypi, poppler_utils, netpbm }:

buildPythonPackage rec {

  pname = "pnglatex";
  version = "1.1";

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

  meta = with lib; {
    homepage = "https://github.com/MaT1g3R/pnglatex";
    description = "a small program that converts LaTeX snippets to png";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
