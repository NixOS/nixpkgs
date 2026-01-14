{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  setuptools,
  setuptools-scm,
  lapack,
  blas,
  suitesparse,
  osqp,
  fftw,
  glpk,
  gsl,
  gurobi,
  gurobipy,
  numpy,
  withGlpk ? true,
  withOsqp ? true,
  withGsl ? true,
  withFftw ? true,
  withGurobi ? false,
  gurobiHome ? null,
}:
buildPythonPackage rec {
  pname = "kvxopt";
  version = "1.3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanurielf";
    repo = "kvxopt";
    tag = version;
    hash = "sha256-m/CU5tgYht5E6Dh3dJqxQ1bE6CSJGGsNSHtn07BjCNs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "kvxopt" ];

  dependencies =
    [
      lapack
      blas
      suitesparse
    ]
    ++ lib.optionals withOsqp [
      osqp
    ]
    ++ lib.optionals withFftw [
      fftw
    ]
    ++ lib.optionals withGlpk [
      glpk
    ]
    ++ lib.optionals withGsl [
      gsl
    ]
    ++ lib.optionals withGurobi ([ gurobipy ] ++ lib.optional (gurobiHome == null) gurobi);

  env =
    lib.optionalAttrs withGsl {
      KVXOPT_BUILD_GSL = 1;
      KVXOPT_GSL_LIB_DIR = "${gsl}/lib";
      KVXOPT_GSL_INC_DIR = "${gsl}/include/gsl";
    }
    // lib.optionalAttrs withFftw {
      KVXOPT_BUILD_FFTW = 1;
      KVXOPT_FFTW_LIB_DIR = "${fftw}/lib";
      KVXOPT_FFTW_INC_DIR = "${fftw}/include";
    }
    // lib.optionalAttrs withGlpk {
      KVXOPT_BUILD_GLPK = 1;
      KVXOPT_GLPK_LIB_DIR = "${glpk}/lib";
      KVXOPT_GLPK_INC_DIR = "${glpk}/include";
    }
    // lib.optionalAttrs withOsqp {
      KVXOPT_BUILD_OSQP = 1;
      KVXOPT_OSQP_LIB_DIR = "${osqp}/lib";
      KVXOPT_OSQP_INC_DIR = "${osqp}/include/osqp";
    }
    // lib.optionalAttrs withGurobi {
      KVXOPT_BUILD_GRB = 1;
      KVXOPT_GRB_LIB_DIR = "${gurobi}/lib";
      KVXOPT_GRB_INC_DIR = "${gurobi}/include";
      KVXOPT_GRB_LIB = "gurobi${builtins.concatStringsSep "" (lib.take 2 (builtins.splitVersion gurobi.version))}";
    };

  nativeCheckInputs = [
    unittestCheckHook
    numpy
  ];

  makeWrapperArgs = lib.optional withGurobi "--set GUROBI_HOME ${
    if gurobiHome == null then gurobi.outPath else gurobiHome
  }";

  unittestFlags = [
    "-s"
    "tests"
    "-v"
  ];

  meta = with lib; {
    description = "Python Software for Convex Optimization containing more wrappers suite-sparse";
    homepage = "https://github.com/sanurielf/kvxopt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ renesat ];
  };
}
