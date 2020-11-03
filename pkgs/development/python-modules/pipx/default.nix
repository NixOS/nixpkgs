{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, userpath
, argcomplete
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pipx";
  version = "0.15.5.1";

  disabled = pythonOlder "3.6";

  # no tests in the pypi tarball, so we directly fetch from github
  src = fetchFromGitHub {
    owner = "pipxproject";
    repo = pname;
    rev = version;
    sha256 = "0lq8dfkq4ji11r4k5csqzyv0757fbxiax6ixn94f9747zrikssf6";
  };

  requiredPythonModules = [ userpath argcomplete packaging ];

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # disable tests, which require internet connection
  disabledTests = [
    "install"
    "inject"
    "ensure_null_pythonpath"
    "missing_interpreter"
    "cache"
    "internet"
    "runpip"
    "upgrade"
  ];

  meta = with lib; {
    description =
      "Install and Run Python Applications in Isolated Environments";
    homepage = "https://github.com/pipxproject/pipx";
    license = licenses.mit;
    maintainers = with maintainers; [ yevhenshymotiuk ];
  };
}
