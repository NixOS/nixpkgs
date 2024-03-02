{ lib
, argcomplete
, buildPythonPackage
, fetchFromGitHub
, hatchling
, importlib-metadata
, packaging
, pip
, platformdirs
, pytestCheckHook
, pythonOlder
, userpath
, git
}:

buildPythonPackage rec {
  pname = "pipx";
  version = "1.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pipxproject";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JZt4I0zw/Kmdgpd5tw6c+fHrHuxkN6jvN3fDmk0//vc=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    argcomplete
    packaging
    platformdirs
    userpath
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
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
  ];

  meta = with lib; {
    description = "Install and run Python applications in isolated environments";
    homepage = "https://github.com/pipxproject/pipx";
    changelog = "https://github.com/pypa/pipx/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ yshym ];
  };
}
