{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "vncdotool";
  version = "1.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "vncdotool";
    tag = "v${version}";
    hash = "sha256-CXxuaAi/B7NiGp1dhhe7iBw0qOdPfsKg7zMMwavGCW8=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pillow
    cryptography
    twisted
  ];

  nativeCheckInputs = with python3Packages; [
    pexpect
    pytestCheckHook
    pyvirtualdisplay
  ];

  #  Disable integration tests that require LibVNCServer examples.
  #  The pure Nix sandbox prohibits vncdotool to download these.
  #
  #  libvncserver outputs do not include examples since upstream
  #  LibVNCServer does not easily provide examples.
  #
  #  Perhaps a Patch to tests/functional/libvncserver.py to provide
  #  LibVNCServer examples via eg. LIBVNCSERVER_DIR is a solution.
  disabledTestPaths = [ "tests/functional" ];

  pythonImportsCheck = [ "vncdotool" ];

  meta = {
    description = "Command line VNC client and Python library";
    homepage = "https://github.com/sibson/vncdotool";
    changelog = "https://github.com/sibson/vncdotool/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "vncdo";
    platforms = with lib.platforms; linux ++ darwin;
  };
}
