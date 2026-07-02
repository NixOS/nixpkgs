{
  lib,
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
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-build";
    repo = "scikit-build-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JE6z44u1FLfI+Gguhd2rVUvY8tyEoo/WviGJmPRT8kc=";
  };

  patches = [
    (fetchpatch {
      name = "setuptools-scm-10-compat.patch";
      url = "https://github.com/scikit-build/scikit-build-core/commit/1b870c538bf7ca679fc4a6e0cbba301c98d9ac35.patch";
      hash = "sha256-JUxBvKiAHpDlIIFkvU+CflTNA6m/auxW5wd5cVYpvcM=";
    })
  ];

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

  disabledTests = [
    # wheel tags generated with wrong system name/version
    "test_wheel_tag"
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
