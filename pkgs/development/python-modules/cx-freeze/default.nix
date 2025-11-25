{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  filelock,
  packaging,
  tomli,

  distutils,
  pythonOlder,
  ncurses,
  patchelf,
  dmgbuild,

  # tests
  ensureNewerSourcesForZipFilesHook,
  pytest-mock,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "cx-freeze";
  version = "8.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcelotduarte";
    repo = "cx_Freeze";
    tag = version;
    hash = "sha256-PhUzHSn9IqUcb11D0kRT8zhmZ/KusTBDpAempiDN4Rc=";
  };

  patches = [
    # ValueError: '/nix/store/33ajdw6s479bg0ydhk0zqrxi6p989gbl-python3.12-pytest-8.3.5/lib/python3.12/site-packages'
    # is not in the subpath of '/nix/store/fqm9bqqlmaqqr02qbalm1bazp810qfiw-python3-3.12.9'
    ./fix-tests-relative-path.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=77.0.3,<=80.4.0" "setuptools>=77.0.3"
  '';

  build-system = [
    setuptools
  ];

  buildInputs = [ ncurses ];

  pythonRelaxDeps = [ "setuptools" ];

  pythonRemoveDeps = [ "patchelf" ];

  dependencies = [
    distutils
    filelock
    packaging
    setuptools
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    dmgbuild
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ patchelf ])
  ];

  pythonImportsCheck = [
    "cx_Freeze"
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/cxfreeze";
  versionCheckProgramArg = "--version";

  preCheck = ''
    rm -rf cx_Freeze
  '';

  disabledTests = [
    # Require internet access
    "test_bdist_appimage_download_appimagetool"
    "test_bdist_appimage_target_name"
    "test_bdist_appimage_target_name_and_version"
    "test_bdist_appimage_target_name_and_version_none"

    # Try to install a module: ValueError: ZIP does not support timestamps before 1980
    "test___main__"
    "test_bdist_appimage_simple"
    "test_bdist_appimage_skip_build"
    "test_bdist_deb_simple_pyproject"
    "test_bdist_rpm_simple_pyproject"
    "test_build"
    "test_build_constants"
    "test_build_exe_advanced"
    "test_build_exe_asmodule"
    "test_ctypes"
    "test_cxfreeze"
    "test_cxfreeze_debug_verbose"
    "test_cxfreeze_deprecated_behavior"
    "test_cxfreeze_deprecated_option"
    "test_cxfreeze_include_path"
    "test_cxfreeze_target_name_not_isidentifier"
    "test_excludes"
    "test_executable_namespace"
    "test_executable_rename"
    "test_executables"
    "test_freezer_zip_filename"
    "test_install"
    "test_install_pyproject"
    "test_multiprocessing"
    "test_not_found_icon"
    "test_parser"
    "test_sqlite"
    "test_ssl"
    "test_tz"
    "test_valid_icon"
    "test_zip_exclude_packages"
    "test_zip_include_packages"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # error: Path /nix/store/xzjghvsg4fhr2vv6h4scihsdrgk4i76w-python3-3.12.9/lib/libpython3.12.dylib
    # is not a path referenced from DarwinFile
    "test_bdist_dmg"
    "test_bdist_dmg_custom_layout"
    "test_bdist_mac"
    "test_plist_items"

    # AssertionError: assert names != []
    "test_freezer_default_bin_includes"
  ];

  meta = {
    description = "Set of scripts and modules for freezing Python scripts into executables";
    homepage = "https://marcelotduarte.github.io/cx_Freeze";
    changelog = "https://github.com/marcelotduarte/cx_Freeze/releases/tag/${src.tag}";
    license = lib.licenses.psfl;
    maintainers = [ ];
    mainProgram = "cxfreeze";
  };
}
