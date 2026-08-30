{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  dask,
  numpy,
  scipy,
  pims,

  # tests
  pyarrow,
  pytestCheckHook,
  scikit-image,
}:

buildPythonPackage (finalAttrs: {
  pname = "dask-image";
  version = "2026.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-image";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SEbabXZx4u+C4IjzfVf81Y/gopxt6m0Jp0ZCN9hx5G8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--flake8" ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dask
    numpy
    pims
    scipy
  ];

  nativeCheckInputs = [
    pyarrow
    pytestCheckHook
    scikit-image
  ];

  pythonImportsCheck = [ "dask_image" ];

  disabledTests = [
    # The following tests are from 'tests/test_dask_image/test_ndmeasure/test_find_objects.py' and
    # fail because of errors on numpy slices
    # AttributeError: 'str' object has no attribute 'start'
    "test_find_objects"
    "test_3d_find_objects"

    # AssertionError (comparing slices)
    "test_find_objects_with_empty_chunks"

    # scipy compat issue
    # TypeError: only 0-dimensional arrays can be converted to Python scalars
    "test_generic_filter_identity"
    "test_generic_filter_comprehensions"
  ];

  meta = {
    description = "Distributed image processing";
    homepage = "https://github.com/dask/dask-image";
    changelog = "https://github.com/dask/dask-image/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
