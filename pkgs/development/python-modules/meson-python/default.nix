{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system, dependencies
  meson,
  ninja,
  pyproject-metadata,
  tomli,

  # tests
  cython,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "meson-python";
  version = "0.18.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-xWqZ7J32aaQGYv5GlgMhr25LFBBsFNsihwnBYo4jhI0=";
  };

  build-system = [
    meson
    ninja
    pyproject-metadata
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  dependencies = [
    meson
    ninja
    pyproject-metadata
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    cython
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # Tests require a Git checkout
    "test_configure_data"
    "test_contents"
    "test_contents"
    "test_contents_license_file"
    "test_contents_subdirs"
    "test_contents_unstaged"
    "test_detect_wheel_tag_module"
    "test_detect_wheel_tag_script"
    "test_dynamic_version"
    "test_editable_install"
    "test_editable_verbose"
    "test_editble_reentrant"
    "test_entrypoints"
    "test_executable_bit"
    "test_executable_bit"
    "test_generated_files"
    "test_install_subdir"
    "test_license_pep639"
    "test_limited_api"
    "test_link_library_in_subproject"
    "test_local_lib"
    "test_long_path"
    "test_meson_build_metadata"
    "test_pep621_metadata"
    "test_pure"
    "test_purelib_and_platlib"
    "test_reproducible"
    "test_rpath"
    "test_scipy_like"
    "test_sharedlib_in_package"
    "test_symlinks"
    "test_uneeded_rpath"
    "test_user_args"
    "test_vendored_meson"
  ];

  setupHooks = [ ./add-build-flags.sh ];

  meta = {
    changelog = "https://github.com/mesonbuild/meson-python/blob/${version}/CHANGELOG.rst";
    description = "Meson Python build backend (PEP 517)";
    homepage = "https://github.com/mesonbuild/meson-python";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ doronbehar ];
    teams = [ lib.teams.python ];
  };
}
