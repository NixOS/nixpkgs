{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  applyPatches,

  # build-system
  cmake,
  ninja,
  scikit-build-core,
  pybind11,
  setuptools-scm,

  # dependencies
  jinja2,
  joblib,
  numpy,
  scipy,

  # tests
  cvxopt,
  pytestCheckHook,
  torch,
}:

let
  qdldl_src = fetchFromGitHub {
    owner = "osqp";
    repo = "qdldl";
    tag = "v0.1.8";
    hash = "sha256-qCeOs4UjZLuqlbiLgp6BMxvw4niduCPDOOqFt05zi2E=";
  };

  osqp_src = applyPatches {
    src = fetchFromGitHub {
      owner = "osqp";
      repo = "osqp";
      tag = "v1.0.0";
      hash = "sha256-BOAytzJzHcggncQzeDrXwJOq8B3doWERJ6CKIVg1yJY=";
    };
    patches = [
      (replaceVars ./dont-fetch-qdldl.patch {
        inherit qdldl_src;
      })
    ];
  };
in

buildPythonPackage (finalAttrs: {
  pname = "osqp";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osqp";
    repo = "osqp-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v7Kyiu5L9/GvnJFx2e6G38hkQvFQeecZNy09NJRjuA0=";
  };

  patches = [
    (replaceVars ./dont-fetch-osqp.patch {
      inherit osqp_src;
    })
  ];

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
    setuptools-scm
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    jinja2
    joblib
    numpy
    scipy
  ];

  nativeCheckInputs = [
    cvxopt
    pytestCheckHook
    torch
  ];

  pythonImportsCheck = [ "osqp" ];

  disabledTestPaths = [
    # CalledProcessError
    # Try to invoke `python setup.py build_ext --inplace`
    "src/osqp/tests/codegen_matrices_test.py"
    "src/osqp/tests/codegen_vectors_test.py"
  ];

  meta = {
    description = "Operator Splitting QP Solver";
    longDescription = ''
      Numerical optimization package for solving problems in the form
        minimize        0.5 x' P x + q' x
        subject to      l <= A x <= u

      where x in R^n is the optimization variable
    '';
    homepage = "https://osqp.org/";
    downloadPage = "https://github.com/oxfordcontrol/osqp-python/releases";
    changelog = "https://github.com/osqp/osqp-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
  };
})
