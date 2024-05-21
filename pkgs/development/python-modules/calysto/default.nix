{ lib
, buildPythonPackage
, fetchFromGitHub
, metakernel
, svgwrite
, ipywidgets
, cairosvg
, numpy
}:

buildPythonPackage rec {
  pname = "calysto";
  version = "1.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Calysto";
    repo = "calysto";
    rev = "v${version}";
    hash = "sha256-lr/cHFshpFs/PGMCsa3FKMRPTP+eE9ziH5XCpV+KzO8=";
  };

  propagatedBuildInputs = [
    metakernel
    svgwrite
    ipywidgets
    cairosvg
    numpy
  ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "calysto" ];

  meta = with lib; {
    description = "Tools for Jupyter and Python";
    homepage = "https://github.com/Calysto/calysto";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kranzes ];
  };
}
