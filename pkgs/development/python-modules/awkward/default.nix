{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  hatch-fancy-pypi-readme,
  hatchling,

  # dependencies
  awkward-cpp,
  fsspec,
  numpy,
  packaging,
  typing-extensions,
  importlib-metadata,

  # checks
  numba,
  setuptools,
  numexpr,
  pandas,
  pyarrow,
  pytest-xdist,
  pytestCheckHook,
  jax,
  jaxlib,

  stdenv,
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "awkward";
    rev = "refs/tags/v${version}";
    hash = "sha256-EcBSPW+us6RjxQu+rNc+++5vGsXyeJB27/Zuth3wacc=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies =
    [
      awkward-cpp
      fsspec
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
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      # no support for darwin
      jax
      jaxlib
    ];

  # The following tests have been disabled because they need to be run on a GPU platform.
  disabledTestPaths = [
    "tests-cuda"
    # Disable tests dependending on jax on darwin
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_2603_custom_behaviors_with_jax.py" ];

  disabledTests = [
    # AssertionError: Regex pattern did not match.
    "test_serialise_with_nonserialisable_attrs"
    "test_serialise_with_nonserialisable_attrs"
  ];

  meta = {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
