{
  lib,
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

buildPythonPackage (finalAttrs: {
  pname = "awkward";
  version = "2.8.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x+DSjNY2DfVq2+JYp/bCsfKOULLxKYGqgIVacfs5Se8=";
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

  disabledTestPaths = [
    # Need to be run on a GPU platform.
    "tests-cuda/*"
  ];

  meta = {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
