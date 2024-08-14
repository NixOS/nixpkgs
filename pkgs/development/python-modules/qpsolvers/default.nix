{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  flit-core,
  numpy,
  scipy,

  # optional dependencies
  clarabel,
  cvxopt,
  daqp,
  ecos,
  gurobipy,
  osqp,
  quadprog,
  scs,
  highspy,
}:
buildPythonPackage rec {
  pname = "qpsolvers";
  version = "4.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qpsolvers";
    repo = "qpsolvers";
    rev = "refs/tags/v${version}";
    hash = "sha256-AQHd3tBfPzISQXsXHQQyh59nmym5gt8Jfogd6gRG3EM=";
  };

  nativeBuildInputs = [ flit-core ];

  pythonImportsCheck = [ "qpsolvers" ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  passthru.optional-dependencies = {
    # FIXME commented out solvers have not been packaged yet
    clarabel = [ clarabel ];
    cvxopt = [ cvxopt ];
    daqp = [ daqp ];
    ecos = [ ecos ];
    gurobi = [ gurobipy ];
    highs = [ highspy ];
    # mosek = [ cvxopt mosek ];
    osqp = [ osqp ];
    # piqp = [ piqp ];
    # proxqp = [ proxsuite ];
    # qpalm = [ qpalm ];
    quadprog = [ quadprog ];
    scs = [ scs ];
    open_source_solvers =
      with passthru.optional-dependencies;
      lib.flatten [
        clarabel
        cvxopt
        daqp
        osqp # piqp proxqp qpalm
        ecos
        highs
        quadprog
        scs
      ];
  };

  nativeCheckInputs = [ unittestCheckHook ] ++ passthru.optional-dependencies.open_source_solvers;

  meta = with lib; {
    changelog = "https://github.com/qpsolvers/qpsolvers/blob/${src.rev}/CHANGELOG.md";
    description = "Quadratic programming solvers in Python with a unified API";
    homepage = "https://github.com/qpsolvers/qpsolvers";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ renesat ];
  };
}
