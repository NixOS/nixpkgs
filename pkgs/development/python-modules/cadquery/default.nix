{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  nix-update-script,

  # build-system
  setuptools,

  # dependencies
  cadquery-ocp,
  casadi,
  ezdxf,
  ipython,
  multimethod,
  nlopt,
  numba,
  pyparsing,
  runtype,
  scipy,
  trame-components,
  trame-vtk,
  trame,
  trame-vuetify,

  # tests
  docutils,
  pytest-xdist,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "cadquery";
  version = "2.8.0";
  pyproject = true;
  disabled = !isPy3k;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "cadquery";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A+d1TvCK7wp05Ib4enTiPdrq4ctPQX2XxZysGLuURTU=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    cadquery-ocp
    casadi
    ezdxf
    ipython
    multimethod
    nlopt
    numba
    pyparsing
    runtype
    scipy
    trame
    trame-components
    trame-vtk
    trame-vuetify
  ];

  nativeCheckInputs = [
    docutils
    pytest-xdist
    pytestCheckHook
  ];

  pythonRelaxDeps = [ "multimethod" ];
  pythonRemoveDeps = [
    "cadquery-ocp"
    "casadi"
  ];

  pythonImportsCheck = [ "cadquery" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parametric scripting language for creating and traversing CAD models";
    homepage = "https://github.com/CadQuery/cadquery";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
