{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatch-fancy-pypi-readme
, hatchling
, awkward-cpp
, importlib-metadata
, numpy
, packaging
, typing-extensions
, fsspec
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
  version = "2.4.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NR3blaVATdNmngntKCyMWsmSRC6QMfLlGHi0UqtaNhI=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    awkward-cpp
    importlib-metadata
    numpy
    packaging
  ]  ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awkward" ];

  nativeCheckInputs = [
    fsspec
    jax
    jaxlib
    numba
    setuptools
    numexpr
    pandas
    pyarrow
    pytest-xdist
    pytestCheckHook
  ];

  # The following tests have been disabled because they need to be run on a GPU platform.
  disabledTestPaths = [
    "tests-cuda"
    "tests-cuda-kernels"
  ];

  meta = with lib; {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
