{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  hatch-vcs,
  hatchling,
  cmake,
  ninja,

  # dependencies
  packaging,
  pathspec,

  # tests
  build,
  cattrs,
  numpy,
  pybind11,
  pytest-subprocess,
  pytestCheckHook,
  setuptools,
  virtualenv,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "scikit-build-core";
  version = "0.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-build";
    repo = "scikit-build-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBTDacTkeclz+/X0SUl1xkxLz4zsfeLOD4Ew0V1Y1iU=";
  };

  # TODO: Rebuild avoidance; clean up on `staging`.
  ${if stdenv.hostPlatform.isDarwin then "patches" else null} = [
    # Backport an upstream commit to fix the tests on Darwin.
    (fetchpatch {
      url = "https://github.com/scikit-build/scikit-build-core/commit/c30f52a3b2bd01dc05f23d3b89332c213006afe0.patch";
      excludes = [ ".github/workflows/ci.yml" ];
      hash = "sha256-5E9QfF5UcSNY1wzHzieEEHEPYzPjUTb66CKCodYb9vo=";
    })
  ];

  postPatch = "";

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    packaging
    pathspec
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
  setupHooks = [
    ./append-cmakeFlags.sh
  ];

  disabledTestMarks = [
    "isolated"
    "network"
  ];

  disabledTestPaths = [
    # store permissions issue in Nix:
    "tests/test_editable.py"
  ];

  pythonImportsCheck = [ "scikit_build_core" ];

  meta = {
    description = "Next generation Python CMake adaptor and Python API for plugins";
    homepage = "https://github.com/scikit-build/scikit-build-core";
    changelog = "https://github.com/scikit-build/scikit-build-core/blob/${finalAttrs.src.tag}/docs/about/changelog.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
