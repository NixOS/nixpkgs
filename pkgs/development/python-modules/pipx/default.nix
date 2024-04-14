{ lib
, argcomplete
, buildPythonPackage
, fetchFromGitHub
, hatchling
, hatch-vcs
, installShellFiles
, packaging
, platformdirs
, pytestCheckHook
, pythonOlder
, tomli
, userpath
, git
}:

buildPythonPackage rec {
  pname = "pipx";
  version = "1.4.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "pipx";
    rev = "refs/tags/${version}";
    hash = "sha256-NxXOeVXwBhGqi4DUABV8UV+cDER0ROBFdgiyYTzdvuo=";
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
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeBuildInputs = [
      installShellFiles
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
    "test_list_short"
    "test_skip_maintenance"
  ];

  postInstall =  ''
    installShellCompletion --cmd pipx \
      --bash <(${argcomplete}/bin/register-python-argcomplete pipx --shell bash) \
      --zsh <(${argcomplete}/bin/register-python-argcomplete pipx --shell zsh) \
      --fish <(${argcomplete}/bin/register-python-argcomplete pipx --shell fish)
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
