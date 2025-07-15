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

buildPythonPackage rec {
  pname = "awkward";
  version = "2.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward";
    tag = "v${version}";
    hash = "sha256-vcVJ9dLiZ3wfZU989slefSJoD2hKlRCwxRALvRGLZPA=";
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
    "tests-cuda"
  ];

  meta = {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
