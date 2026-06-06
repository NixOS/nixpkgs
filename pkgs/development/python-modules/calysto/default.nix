{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  metakernel,
  svgwrite,
  ipywidgets,
  cairosvg,
  numpy,
}:

buildPythonPackage rec {
  pname = "calysto";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Calysto";
    repo = "calysto";
    rev = "v${version}";
    hash = "sha256-lr/cHFshpFs/PGMCsa3FKMRPTP+eE9ziH5XCpV+KzO8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    metakernel
    svgwrite
    ipywidgets
    cairosvg
    numpy
  ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "calysto" ];

  meta = {
    description = "Tools for Jupyter and Python";
    homepage = "https://github.com/Calysto/calysto";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
