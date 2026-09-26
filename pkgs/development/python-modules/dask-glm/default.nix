{
  lib,
  config,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cudaSupport ? config.cudaSupport,

  # build-system
  setuptools_80,
  setuptools-scm,

  # dependencies
  cloudpickle,
  distributed,
  multipledispatch,
  scikit-learn,
  scipy,
  sparse,
  dask,

  # tests
  cupy,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dask-glm";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-glm";
    tag = finalAttrs.version;
    hash = "sha256-u3KASmBamc7qU/GxGT0QBqWJ1HDk81xI0MOoRng8BzA=";
  };

  # Use pinned setuptools for pkg_resources
  build-system = [
    setuptools_80
    setuptools-scm
  ];

  dependencies = [
    cloudpickle
    distributed
    multipledispatch
    scikit-learn
    scipy
    sparse
  ]
  ++ dask.optional-dependencies.array;

  # Tests want write access to the sandbox, faiil with access to .homeless-shelter otherwise
  preCheck = ''
    export CUPY_CACHE_DIR=$(mktemp -d)
  '';

  nativeCheckInputs = [
    cupy
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dask_glm" ];

  disabledTests = [
    # ValueError: <class 'bool'> can be computed for one-element arrays only.
    "test_dot_with_sparse"

    # ValueError: `shape` was not provided.
    "test_sparse"
  ];

  disabledTestPaths = [
    # TypeError: fmin_l_bfgs_b() got an unexpected keyword argument 'iprint'
    "dask_glm/tests/test_algos_families.py::test_basic_unreg_descent"
    "dask_glm/tests/test_algos_families.py::test_methods"
  ]
  ++ lib.optionals (!cudaSupport) [
    # cupy_backends.cuda.api.runtime.CUDARuntimeError: cudaErrorInsufficientDrive...
    "dask_glm/tests/test_algos_families.py::test_basic_reg_descent"
    "dask_glm/tests/test_algos_families.py::test_basic_unreg_descent"
    "dask_glm/tests/test_algos_families.py::test_methods"
    "dask_glm/tests/test_estimators.py::test_fit"
    "dask_glm/tests/test_estimators.py::test_lm"
    "dask_glm/tests/test_utils.py::test_dot_with_cupy"
  ];

  # On darwin, tests saturate the entire system, even when constrained to run single-threaded
  # Removing pytest-xdist AND setting --cores to one does not prevent the load from exploding
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Generalized Linear Models with Dask";
    homepage = "https://github.com/dask/dask-glm/";
    changelog = "https://github.com/dask/dask-glm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
