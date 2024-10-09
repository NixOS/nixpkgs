{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatch-vcs,
  hatchling,
  cmake,
  ninja,

  # dependencies
  packaging,
  pathspec,
  exceptiongroup,

  # tests
  build,
  cattrs,
  numpy,
  pybind11,
  pytest-subprocess,
  pytestCheckHook,
  setuptools,
  tomli,
  virtualenv,
  wheel,
}:

buildPythonPackage rec {
  pname = "scikit-build-core";
  version = "0.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-build";
    repo = "scikit-build-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-R6/Y9brIYBA1P3YeG8zGaoPcxWFUDqZlqbZpWu3MIIw=";
  };

  postPatch = lib.optionalString (pythonOlder "3.11") ''
    substituteInPlace pyproject.toml \
      --replace-fail '"error",' '"error", "ignore::UserWarning",'
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies =
    [
      packaging
      pathspec
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      exceptiongroup
      tomli
    ];

  nativeCheckInputs = [
    build
    cattrs
    cmake
    ninja
    numpy
    pybind11
    pytest-subprocess
    pytestCheckHook
    setuptools
    virtualenv
    wheel
  ];

  # cmake is only used for tests
  dontUseCmakeConfigure = true;

  pytestFlagsArray = [ "-m 'not isolated and not network'" ];

  disabledTestPaths = [
    # store permissions issue in Nix:
    "tests/test_editable.py"
  ];

  pythonImportsCheck = [ "scikit_build_core" ];

  meta = with lib; {
    description = "Next generation Python CMake adaptor and Python API for plugins";
    homepage = "https://github.com/scikit-build/scikit-build-core";
    changelog = "https://github.com/scikit-build/scikit-build-core/blob/${src.rev}/docs/changelog.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
