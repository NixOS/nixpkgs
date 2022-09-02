{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatchling
, userpath
, argcomplete
, packaging
, importlib-metadata
, pip
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pipx";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  # no tests in the pypi tarball, so we directly fetch from github
  src = fetchFromGitHub {
    owner = "pipxproject";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-6cKKVOgHIoKNfGqvDWK5cwBGBDkgfyRuBRDV6fruBoA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    userpath
    argcomplete
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
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
    description =
      "Install and Run Python Applications in Isolated Environments";
    homepage = "https://github.com/pipxproject/pipx";
    license = licenses.mit;
    maintainers = with maintainers; [ yshym ];
  };
}
