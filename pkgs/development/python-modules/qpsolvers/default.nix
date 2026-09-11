{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  flit-core,

  # dependencies
  numpy,
  scipy,

  # optional-dependencies
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

  # tests
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "qpsolvers";
  version = "4.13.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "qpsolvers";
    repo = "qpsolvers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JgrfHyZ5bhD5XBuxZsASnmFU080XZs0EjdOOj5Lr1Hg=";
  };

  build-system = [ flit-core ];

  dependencies = [
    numpy
    scipy
  ];

  optional-dependencies = lib.fix (self: {
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
      with self;
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
  });

  pythonImportsCheck = [ "qpsolvers" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.open_source_solvers;

  enabledTestPaths = [ "tests/" ];

  pytestFlags = [
    # Marginally exceed the hard-coded tolerances with scs 3.3.0.
    # `disabledTests` cannot be used: `test_scs` is a substring of other, passing test IDs
    "--deselect=tests/test_solve_ls.py::TestSolveLS::test_scs"
    "--deselect=tests/test_solve_qp.py::TestSolveQP::test_bounds_scs"
    "--deselect=tests/test_solve_qp.py::TestSolveQP::test_scs"
    "--deselect=tests/test_solve_qp.py::TestSolveQP::test_sparse_bounds_scs"
    "--deselect=tests/test_solve_qp.py::TestSolveQP::test_warmstart_scs"
  ];

  meta = {
    description = "Quadratic programming solvers in Python with a unified API";
    changelog = "https://github.com/qpsolvers/qpsolvers/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://github.com/qpsolvers/qpsolvers";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ renesat ];
  };
})
