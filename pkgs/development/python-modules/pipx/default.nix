{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  installShellFiles,
  packaging,
  platformdirs,
  pytestCheckHook,
  pythonOlder,
  tomli,
  userpath,
  git,
}:

buildPythonPackage rec {
  pname = "pipx";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "pipx";
    rev = "refs/tags/${version}";
    hash = "sha256-B57EIUIwy0XG5bnIwxYKgm3WwckdJWWAeUl84mWC1Ds=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    argcomplete
    packaging
    platformdirs
    userpath
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeBuildInputs = [
    installShellFiles
    argcomplete
  ];

  nativeCheckInputs = [
    pytestCheckHook
    git
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    "--ignore=tests/test_install_all_packages.py"
    # start local pypi server and use in tests
    "--net-pypiserver"
  ];

  disabledTests = [
    # disable tests which are difficult to emulate due to shell manipulations
    "path_warning"
    "script_from_internet"
    "ensure_null_pythonpath"
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
  ];

  postInstall = ''
    installShellCompletion --cmd pipx \
      --bash <(register-python-argcomplete pipx --shell bash) \
      --zsh <(register-python-argcomplete pipx --shell zsh) \
      --fish <(register-python-argcomplete pipx --shell fish)
  '';

  meta = with lib; {
    description = "Install and run Python applications in isolated environments";
    mainProgram = "pipx";
    homepage = "https://github.com/pypa/pipx";
    changelog = "https://github.com/pypa/pipx/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ yshym ];
  };
}
