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
  version = "2024.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-image";
    tag = "v${version}";
    hash = "sha256-kXCAqJ2Zgo/2Khvo2YcK+n4oGM219GyQ2Hsq9re1Lac=";
  };

  postPatch = ''
    substituteInPlace dask_image/ndinterp/__init__.py \
      --replace-fail "out_bounds.ptp(axis=1)" "np.ptp(out_bounds, axis=1)"

    substituteInPlace tests/test_dask_image/test_imread/test_core.py \
      --replace-fail "fh.save(" "fh.write("
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
  ];

  meta = {
    description = "Distributed image processing";
    homepage = "https://github.com/dask/dask-image";
    changelog = "https://github.com/dask/dask-image/releases/tag/v${version}";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
