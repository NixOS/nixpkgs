{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  docutils,
  hatch-vcs,
  hatchling,

  # nativeBuildInputs
  installShellFiles,

  # dependencies
  argcomplete,
  colorama,
  filelock,
  packaging,
  platformdirs,
  userpath,

  # optional-dependencies
  uv,

  # tests
  gitMinimal,
  pypiserver,
  pytest-cov-stub,
  pytest-mock,
  pytest-subprocess,
  pytest-xdist,
  pytestCheckHook,
  watchdog,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pipx";
  version = "1.16.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "pipx";
    tag = finalAttrs.version;
    hash = "sha256-2su1kJHrSYGnTKCXvWCWRQUMlR0oEhno90D57UIOCJU=";
  };

  patches = [
    # Keep dependencies from Nix's PYTHONPATH visible to the subprocess import test.
    ./preserve-pythonpath-in-import-test.patch
  ];

  build-system = [
    docutils
    hatchling
    hatch-vcs
  ];

  dependencies = [
    argcomplete
    colorama
    filelock
    packaging
    platformdirs
    userpath
  ];

  optional-dependencies = {
    uv = [
      uv
    ];
  };

  nativeBuildInputs = [
    argcomplete
    installShellFiles
  ];

  nativeCheckInputs = [
    gitMinimal
    pypiserver
    pytest-cov-stub
    pytest-mock
    pytest-subprocess
    pytest-xdist
    pytestCheckHook
    watchdog
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    # start local pypi server and use in tests
    "--net-pypiserver"
  ];

  disabledTests = [
    # disable tests, which require internet connection
    "cache"
    "determination"
    "ensure_null_pythonpath"
    "execute"
    "expose"
    "health"
    "inject"
    "install"
    "internet"
    "json"
    "legacy_venv"
    "manifest"
    "missing_interpreter"
    "outdated"
    "reset"
    "run"
    "runpip"
    "suffix"
    "test_auto_update_shared_libs"
    "test_cli"
    "test_cli_global"
    "test_contract_success_envelope"
    "test_download_standalone_python_sets_tar_filter"
    "test_download_standalone_python_supports_early_python_310"
    "test_fetch_missing_python"
    "test_list_does_not_trigger_maintenance"
    "test_list_pinned_packages"
    "test_list_selected_package"
    "test_list_short"
    "test_list_standalone_interpreter"
    "test_list_unused_standalone_interpreters"
    "test_list_used_standalone_interpreters"
    "test_pin"
    "test_remove_stale_venv_resources_keeps_files_pipx_does_not_own"
    "test_shared_libs_create_preserves_pip_args"
    "test_shared_libs_excludes_setuptools"
    "test_skip_maintenance"
    "test_unpin"
    "test_unpin_warning"
    "upgrade"
  ];

  # Keep long Darwin sandbox paths from wrapping literal test output.
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export COLUMNS=200
  '';

  postInstall = ''
    installShellCompletion --cmd pipx \
      --bash <(register-python-argcomplete pipx --shell bash) \
      --zsh <(register-python-argcomplete pipx --shell zsh) \
      --fish <(register-python-argcomplete pipx --shell fish)
  '';

  pythonImportsCheck = [ "pipx" ];

  meta = {
    description = "Install and run Python applications in isolated environments";
    mainProgram = "pipx";
    homepage = "https://github.com/pypa/pipx";
    changelog = "https://github.com/pypa/pipx/blob/main/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yshym ];
  };
})
