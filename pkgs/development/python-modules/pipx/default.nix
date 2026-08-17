{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  installShellFiles,
  colorama,
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
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "pipx";
    tag = finalAttrs.version;
    hash = "sha256-4qSCyaYHam9y04qTgEUvbo/XiY9WNqX2fKZJOAVE2EM=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    argcomplete
    colorama
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
    changelog = "https://github.com/pypa/pipx/blob/main/docs/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yshym ];
  };
})
