{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, userpath
, argcomplete
, packaging
, importlib-metadata
, colorama
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pipx";
  version = "0.16.1.0";

  disabled = pythonOlder "3.6";

  # no tests in the pypi tarball, so we directly fetch from github
  src = fetchFromGitHub {
    owner = "pipxproject";
    repo = pname;
    rev = version;
    sha256 = "081raqsaq7i2x4yxhxppv930jhajdwmngin5wazy7vqhiy3xc669";
  };

  propagatedBuildInputs = [
    userpath
    argcomplete
    packaging
    colorama
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # disable tests, which require internet connection
  pytestFlagsArray = [ "--ignore=tests/test_install_all_packages.py" ];
  disabledTests = [
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
  ];

  meta = with lib; {
    description =
      "Install and Run Python Applications in Isolated Environments";
    homepage = "https://github.com/pipxproject/pipx";
    license = licenses.mit;
    maintainers = with maintainers; [ yevhenshymotiuk ];
  };
}
