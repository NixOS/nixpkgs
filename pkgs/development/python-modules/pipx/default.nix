{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchFromGitHub,
  docutils,
  hatchling,
  hatch-vcs,
  installShellFiles,
  colorama,
  filelock,
  packaging,
  platformdirs,
  tomli,
  userpath,
  uv,
  git,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  pypiserver,
  pytest-cov-stub,
  pytest-mock,
  pytest-subprocess,
  pytest-xdist,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "pipx";
  version = "1.16.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "pipx";
    tag = finalAttrs.version;
    hash = "sha256-oeZxtH3Wkx8VIcS+rAYKndbArSez3nO7N8r4sknd7cw=";
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
    tomli
    userpath
  ]
  ++ finalAttrs.passthru.optional-dependencies.uv;

  optional-dependencies = {
    uv = [
      uv
    ];
  };

  nativeBuildInputs = [
    installShellFiles
    argcomplete
  ];

  nativeCheckInputs = [
    pytestCheckHook
    git
    writableTmpDirAsHomeHook
    pypiserver
    pytest-cov-stub
    pytest-mock
    pytest-subprocess
    pytest-xdist
    watchdog
  ];

  pytestFlags = [
    # start local pypi server and use in tests
    "--net-pypiserver"
  ];

  disabledTests = [
    # disable tests, which require internet connection
    "install"
    "inject"
    "ensure_null_pythonpath"
    "missing_interpreter"
    "cache"
    "internet"
    "run"
    "runpip"
    "upgrade"
    "suffix"
    "legacy_venv"
    "determination"
    "json"
    "test_auto_update_shared_libs"
    "test_cli"
    "test_cli_global"
    "test_fetch_missing_python"
    "test_list_does_not_trigger_maintenance"
    "test_list_pinned_packages"
    "test_list_short"
    "test_list_standalone_interpreter"
    "test_list_unused_standalone_interpreters"
    "test_list_used_standalone_interpreters"
    "test_pin"
    "test_skip_maintenance"
    "test_unpin"
    "test_unpin_warning"
    "test_shared_libs_excludes_setuptools"
    "execute"
    "expose"
    "health"
    "manifest"
    "outdated"
    "reset"
    "test_contract_success_envelope"
    "test_download_standalone_python_sets_tar_filter"
    "test_download_standalone_python_supports_early_python_310"
    "test_list_selected_package"
    "test_remove_stale_venv_resources_keeps_files_pipx_does_not_own"
    "test_shared_libs_create_preserves_pip_args"
  ];

  postInstall = ''
    installShellCompletion --cmd pipx \
      --bash <(register-python-argcomplete pipx --shell bash) \
      --zsh <(register-python-argcomplete pipx --shell zsh) \
      --fish <(register-python-argcomplete pipx --shell fish)
  '';

  pythonImportsCheck = [ "pipx" ];

  __structuredAttrs = true;

  meta = {
    description = "Install and run Python applications in isolated environments";
    mainProgram = "pipx";
    homepage = "https://github.com/pypa/pipx";
    changelog = "https://github.com/pypa/pipx/blob/main/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yshym ];
  };
})
