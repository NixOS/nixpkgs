{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-fancy-pypi-readme,
  hatchling,

  # dependencies
  awkward-cpp,
  fsspec,
  numpy,
  packaging,

  # tests
  numba,
  numexpr,
  pandas,
  pyarrow,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "2.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward";
    tag = "v${version}";
    hash = "sha256-OXSl+8sfrx+JlLu40wHf+98WVNNwm9uxvsnGXRDztDg=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    awkward-cpp
    fsspec
    numpy
    packaging
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awkward" ];

  nativeCheckInputs = [
    fsspec
    numba
    numexpr
    pandas
    pyarrow
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # pyarrow.lib.ArrowInvalid
    "test_recordarray"
  ];

  disabledTestPaths =
    [
      # Need to be run on a GPU platform.
      "tests-cuda"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # Fatal Python error: Segmentation fault at:
      # numba/typed/typedlist.py", line 344 in append
      "tests/test_0118_numba_cpointers.py"
      "tests/test_0397_arrays_as_constants_in_numba.py"
      "tests/test_1677_array_builder_in_numba.py"
      "tests/test_2055_array_builder_check.py"
      "tests/test_2349_growablebuffer_in_numba.py"
      "tests/test_2408_layoutbuilder_in_numba.py"
    ];

  meta = {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
