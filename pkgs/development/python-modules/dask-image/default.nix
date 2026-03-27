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
  pandas,
  pims,

  # tests
  pyarrow,
  pytestCheckHook,
  scikit-image,
}:

buildPythonPackage rec {
  pname = "dask-image";
  version = "2025.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-image";
    tag = "v${version}";
    hash = "sha256-+nzYthnobcemunMcAWwRpHOQy6yFtjdib/7VZqWEiqc=";
  };

  postPatch = ''
    sed -i "/--flake8/d" pyproject.toml

    # https://numpy.org/doc/stable//release/2.4.0-notes.html#removed-numpy-in1d
    substituteInPlace tests/test_dask_image/test_ndmeasure/test_core.py \
      --replace-fail "np.in1d" "np.isin"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dask
    numpy
    scipy
    pandas
    pims
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
    changelog = "https://github.com/dask/dask-image/releases/tag/v${version}";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
