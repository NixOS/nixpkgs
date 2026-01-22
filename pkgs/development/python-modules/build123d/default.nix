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
  lib3mf,
  scipy,
  svgpathtools,
  trianglesolver,
}:
let
  pname = "build123d";
  version = "0.9.1";
  src = fetchFromGitHub {
    owner = "gumyr";
    repo = "build123d";
    tag = "v${version}";
    hash = "sha256-pOYK6zXC5z0JohL4k/NMI/ALfHVKSJM5eM2bLcyKhpQ=";
  };
in
buildPythonPackage {
  inherit src pname version;
  pyproject = true;

  # For our purposes, lib3mf is functionally equivalent for py-lib3mf.
  # build123d has switched over on the main branch, but a release has not been cut yet:
  # https://github.com/gumyr/build123d/pull/917
  patchPhase = ''
    substituteInPlace pyproject.toml \
      --replace-fail "py-lib3mf" "lib3mf"
    substituteInPlace src/build123d/mesher.py --replace-fail "py_lib3mf" "lib3mf"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    anytree
    ezdxf
    ipython
    numpy
    cadquery-ocp
    ocpsvg
    lib3mf
    scipy
    svgpathtools
    trianglesolver
  ];

  pythonRelaxDeps = [ "ipython" ];

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
