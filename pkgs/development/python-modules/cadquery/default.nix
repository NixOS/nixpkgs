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
  nptyping,
  path,
  trame-vtk,
  trame,
  typing-extensions,
  typish,
  vtk,

  # tests
  docutils,
  pytest-xdist,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "cadquery";
  version = "2.6.1";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "cadquery";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZIZ49RCGkPztlhU/AmDFnJXvw5kuhF+sSLKZuXMtuCU=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    cadquery-ocp
    casadi
    ezdxf
    ipython
    multimethod
    nlopt
    nptyping
    path
    trame
    trame-vtk
    typing-extensions
    # typish will be removed in the next release: https://github.com/CadQuery/cadquery/pull/1967
    typish
    vtk
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

  # This fails upstream: https://github.com/CadQuery/OCP/issues/192
  # OCP.Standard.Standard_Failure: BRepFill : The continuity is not G0 G1 or G2
  disabledTests = [ "test_cap" ];

  pythonImportsCheck = [ "cadquery" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parametric scripting language for creating and traversing CAD models";
    homepage = "https://github.com/CadQuery/cadquery";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
