{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
  anytree,
  ezdxf,
  ipython,
  numpy,
  cadquery-ocp,
  ocpsvg,
  ocp-gordon,
  lib3mf,
  sympy,
  scipy,
  svgpathtools,
  trianglesolver,
  webcolors,
}:
let
  pname = "build123d";
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "gumyr";
    repo = "build123d";
    tag = "v${version}";
    hash = "sha256-EhV6/ZTBp9XxWY1CgNKESikgTnAk9xaF0g/bYEQPf20=";
  };
in
buildPythonPackage {
  inherit src pname version;
  pyproject = true;

  build-system = [ setuptools-scm ];

  dependencies = [
    anytree
    ezdxf
    ipython
    numpy
    cadquery-ocp
    ocpsvg
    ocp-gordon
    lib3mf
    scipy
    sympy
    svgpathtools
    trianglesolver
    webcolors
  ];

  pythonRelaxDeps = [
    "ipython"
    "webcolors"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # These attempt to access the network
    "test_assembly_with_oriented_parts"
    "test_move_single_object"
    "test_single_label_color"
    "test_single_object"
  ];

  meta = {
    description = "python CAD programming library";
    homepage = "https://github.com/gumyr/build123d";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tnytown ];
  };
}
