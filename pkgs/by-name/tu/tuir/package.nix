{
  lib,
  fetchFromGitLab,
  python3Packages,
}:

with python3Packages;
buildPythonApplication (finalAttrs: {
  pname = "tuir";
  version = "1.31.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "Chocimier";
    repo = "tuir";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lUK6gXwvVjiYrJXMSFlzp07Yt+nSkU933J4vBJWOLlg=";
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

  meta = {
    description = "Browse Reddit from your Terminal (fork of rtv)";
    mainProgram = "tuir";
    homepage = "https://gitlab.com/Chocimier/tuir";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      brokenpip3
    ];
  };
})
