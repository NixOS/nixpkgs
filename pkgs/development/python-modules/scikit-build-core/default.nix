{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      name = "setuptools-75_8-compatibility.patch";
      url = "https://github.com/scikit-build/scikit-build-core/commit/e4e92bc28651001e91999e9759c44fb67cd3d211.patch";
      includes = [ "tests/test_setuptools_pep517.py" ];
      hash = "sha256-nqng1FAY90Qm/yVRkALTsKchqNvsxutbBr51/Q4IKPA=";
    })
  ];

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
