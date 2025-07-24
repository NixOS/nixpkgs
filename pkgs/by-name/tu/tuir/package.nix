{
  lib,
  fetchFromGitLab,
  python3Packages,
}:

with python3Packages;
buildPythonApplication rec {
  pname = "tuir";
  version = "1.31.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "Chocimier";
    repo = "tuir";
    rev = "v${version}";
    hash = "sha256-VYBtD3Ex6+iIRNvX6jF0b0iPvno41/58xCRydiyssvk=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = [
    beautifulsoup4
    decorator
    kitchen
    mailcap-fix
    requests
    six
  ];

  nativeCheckInputs = [
    coverage
    coveralls
    docopt
    mock
    pylint
    pytestCheckHook
    vcrpy
  ];

  __darwinAllowLocalNetworking = true; # for oauth tests

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert ['pbcopy', 'w'] == ['xclip', '-s..., 'clipboard']
    "test_copy_nix"
    # AttributeError: Can't get local object 'Terminal.open_browser.open_browser.<locals>.open_url_silent'
    "test_terminal_open_browser_display"
  ];

  pythonImportsCheck = [ "tuir" ];

  meta = with lib; {
    description = "Browse Reddit from your Terminal (fork of rtv)";
    mainProgram = "tuir";
    homepage = "https://gitlab.com/Chocimier/tuir";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      matthiasbeyer
      brokenpip3
    ];
  };
}
