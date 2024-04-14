{ lib
, fsspec
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatch-fancy-pypi-readme
, hatchling
, awkward-cpp
, importlib-metadata
, numpy
, packaging
, typing-extensions
, jax
, jaxlib
, numba
, setuptools
, numexpr
, pandas
, pyarrow
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "2.6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward";
    rev = "refs/tags/v${version}";
    hash = "sha256-zII5TZ0bzVEo5hTrLr45N7oL3lYhkCyNfZif+0vkEo4=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    awkward-cpp
    fsspec
    importlib-metadata
    numpy
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.12") [
    importlib-metadata
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awkward" ];

  nativeCheckInputs = [
    fsspec
    numba
    setuptools
    numexpr
    pandas
    pyarrow
    pytest-xdist
    pytestCheckHook
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # no support for darwin
    jax
    jaxlib
  ];

  # The following tests have been disabled because they need to be run on a GPU platform.
  disabledTestPaths = [
    "tests-cuda"
  ];

  meta = with lib; {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
