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
  jaxopt,
  osqp,
  quadprog,
  scs,
  highspy,
  piqp,
  proxsuite,
}:
buildPythonPackage rec {
  pname = "qpsolvers";
  version = "4.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qpsolvers";
    repo = "qpsolvers";
    tag = "v${version}";
    hash = "sha256-wiFDsTE+L0J+6GsDz27Xh20eXvtV6KDa2CLGQDYzIGM=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "qpsolvers" ];

  dependencies = [
    numpy
    scipy
  ];

  optional-dependencies = {
    # FIXME commented out solvers have not been packaged yet
    clarabel = [ clarabel ];
    cvxopt = [ cvxopt ];
    daqp = [ daqp ];
    ecos = [ ecos ];
    gurobi = [ gurobipy ];
    highs = [ highspy ];
    jaxopt = [ jaxopt ];
    # mosek = [ cvxopt mosek ];
    osqp = [ osqp ];
    piqp = [ piqp ];
    proxqp = [ proxsuite ];
    # qpalm = [ qpalm ];
    quadprog = [ quadprog ];
    scs = [ scs ];
    open_source_solvers =
      with optional-dependencies;
      lib.flatten [
        clarabel
        cvxopt
        daqp
        ecos
        highs
        osqp
        piqp
        proxqp
        # qpalm
        quadprog
        scs
      ];
  };

  nativeCheckInputs = [ unittestCheckHook ] ++ optional-dependencies.open_source_solvers;

  meta = with lib; {
    changelog = "https://github.com/qpsolvers/qpsolvers/blob/${src.tag}/CHANGELOG.md";
    description = "Quadratic programming solvers in Python with a unified API";
    homepage = "https://github.com/qpsolvers/qpsolvers";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ renesat ];
  };
}
