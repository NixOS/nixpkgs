{
  lib,
  fsspec,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  awkward-cpp,
  importlib-metadata,
  numpy,
  packaging,
  typing-extensions,
  jax,
  jaxlib,
  numba,
  setuptools,
  numexpr,
  pandas,
  pyarrow,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "2.6.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward";
    rev = "refs/tags/v${version}";
    hash = "sha256-HDO626bK5BH/mdLuGkeYIOz8X2N9/rkTLhQNzG1erYA=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies =
    [
      awkward-cpp
      fsspec
      importlib-metadata
      numpy
      packaging
    ]
    ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ]
    ++ lib.optionals (pythonOlder "3.12") [ importlib-metadata ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awkward" ];

  nativeCheckInputs =
    [
      fsspec
      numba
      setuptools
      numexpr
      pandas
      pyarrow
      pytest-xdist
      pytestCheckHook
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      # no support for darwin
      jax
      jaxlib
    ];

  # The following tests have been disabled because they need to be run on a GPU platform.
  disabledTestPaths = [
    "tests-cuda"
    # Disable tests dependending on jax on darwin
  ] ++ lib.optionals stdenv.isDarwin [ "tests/test_2603_custom_behaviors_with_jax.py" ];

  meta = {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
