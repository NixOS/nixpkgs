{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  cloudpickle,
  dask,
  distributed,
  multipledispatch,
  numba,
  numpy,
  scikit-learn,
  scipy,
  sparse,

  # tests
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

  # The iprint parameter of `scipy.optimize.fmin_l_bfgs_b` was removed in 1.18.0
  # https://github.com/scipy/scipy/blob/b881cb179463e85a74f3368f6242986d713adbdc/doc/source/release/1.18.0-notes.rst?plain=1#L291-L292
  postPatch = ''
    substituteInPlace dask_glm/algorithms.py \
      --replace-fail "iprint=(verbose > 0) - 1," ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cloudpickle
    dask
    distributed
    multipledispatch
    numba
    numpy
    scikit-learn
    scipy
    sparse
  ]
  ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dask_glm" ];

  meta = {
    description = "Generalized Linear Models with Dask";
    homepage = "https://github.com/dask/dask-glm/";
    changelog = "https://github.com/dask/dask-glm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
