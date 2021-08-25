{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, userpath
, argcomplete
, packaging
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pipx";
  version = "0.16.3";

  disabled = pythonOlder "3.6";

  # no tests in the pypi tarball, so we directly fetch from github
  src = fetchFromGitHub {
    owner = "pipxproject";
    repo = pname;
    rev = version;
    sha256 = "1w5pzn5mgl9rr9zbmqza5is4mvjvcgjps1q9qa1mvbnyvakdkr4c";
  };

  propagatedBuildInputs = [
    userpath
    argcomplete
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [ pytestCheckHook ];

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
  ];

  meta = with lib; {
    description =
      "Install and Run Python Applications in Isolated Environments";
    homepage = "https://github.com/pipxproject/pipx";
    license = licenses.mit;
    maintainers = with maintainers; [ yevhenshymotiuk ];
  };
}
