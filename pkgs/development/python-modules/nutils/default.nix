{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  appdirs,
  matplotlib,
  meshio,
  numpy,
  nutils-poly,
  scipy,
  stringly,
  treelog,
  pytestCheckHook,
  pythonOlder,
  pkgs,
}:

buildPythonPackage rec {
  pname = "nutils";
  version = "9.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "evalf";
    repo = "nutils";
    tag = "v${version}";
    hash = "sha256-NmWoRDYOfSweqUhw0KTdXubWgXmVr+odrs1dMLXdHEI=";
  };

  build-system = [ flit-core ];

  dependencies = [
    appdirs
    numpy
    nutils-poly
    stringly
    treelog
  ];

  optional-dependencies = {
    export-mpl = [ matplotlib ];
    # TODO: matrix-mkl = [ mkl ];
    matrix-scipy = [ scipy ];
    import-gmsh = [ meshio ];
  };

  pythonRelaxDeps = [ "psutil" ];

  nativeCheckInputs = [
    pkgs.graphviz
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # Error: invalid value 'x' for farg: loading 'x' as float
    "run.test_badvalue"
    "choose.test_badvalue"
    # ModuleNotFoundError: No module named 'stringly'
    "picklability.test_basis"
    "picklability.test_domain"
    "picklability.test_geom"
  ];

  pythonImportsCheck = [ "nutils" ];

  meta = with lib; {
    description = "Numerical Utilities for Finite Element Analysis";
    changelog = "https://github.com/evalf/nutils/releases/tag/${src.tag}";
    homepage = "https://www.nutils.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
