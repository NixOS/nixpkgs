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
<<<<<<< HEAD
  version = "2.8.11";
=======
  version = "2.8.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-76DeL/KIna8Hd9eukCzuRXKO+awkbpc4trCeKTSfGmA=";
=======
    hash = "sha256-zECnqZapgvB9ngkoAwEDFMyebFbE0iJ7Yo/5iLcmRXs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
