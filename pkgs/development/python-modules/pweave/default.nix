{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  matplotlib,
  pkgs,
  nbconvert,
  markdown,
  isPy3k,
  ipykernel,
}:

buildPythonPackage rec {
  pname = "pweave";
  version = "0.30.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "Pweave";
    inherit version;
    hash = "sha256-XlKY2Q4GQUoB9I4NaqTDanDF8iPZKfKpx+LTiEUcc1c=";
  };

  disabled = !isPy3k;

  buildInputs = [
    mock
    pkgs.glibcLocales
  ];
  propagatedBuildInputs = [
    ipykernel
    matplotlib
    nbconvert
    markdown
  ];

  # fails due to trying to run CSS as test
  doCheck = false;

  meta = with lib; {
    description = "Scientific reports with embedded python computations with reST, LaTeX or markdown";
    homepage = "https://mpastell.com/pweave/";
    license = licenses.bsd3;
  };
}
