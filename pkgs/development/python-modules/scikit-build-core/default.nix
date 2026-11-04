{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-build";
    repo = "scikit-build-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/t2NEmArJsPmlTnwzLzoFViBUkC9LNEVDbdBAEPcoHg=";
  };

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
    # creates a cmake dir and is surprised it is recognized as a python module
    "test_cmake_namespace_dir_is_not_a_module"
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
