{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "calysto";
  version = "1.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Calysto";
    repo = "calysto";
    rev = "v${version}";
    hash = "sha256-lr/cHFshpFs/PGMCsa3FKMRPTP+eE9ziH5XCpV+KzO8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    metakernel
    svgwrite
    ipywidgets
    cairosvg
    numpy
  ];

  # Tests are failing not because of Nix.
  doCheck = false;

  pythonImportsCheck = [ "calysto" ];

  meta = with lib; {
    description = "Tools for Jupyter and Python";
    homepage = "https://github.com/Calysto/calysto";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kranzes ];
  };
}
