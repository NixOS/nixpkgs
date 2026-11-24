{
  lib,
  fetchFromGitHub,
  python3Packages,
  ...
}:

python3Packages.buildPythonApplication rec {
  pname = "toothspin";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eknoes";
    repo = "toothspin";
    tag = "v${version}";
    hash = "sha256-NgZFL+EQumvlPy+y7yLnykz5DuxDjcTZrZwMs9HGRuk=";
  };

  pythonRelaxDeps = [ "aiosendspin" ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiomqtt
    aiosendspin
    dbus-fast
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytest-timeout
      pytestCheckHook
    ]
    ++ aiosendspin.optional-dependencies.server;

  pythonImportsCheck = [ "toothspin" ];

  disabledTestPaths = [
    # no mDNS in the sandbox
    "tests/test_server.py"
  ];

  meta = {
    description = "Bluetooth audio input for Sendspin and Music Assistant";
    homepage = "https://github.com/eknoes/toothspin";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.SuperSandro2000 ];
    mainProgram = "toothspin";
    platforms = lib.platforms.linux;
  };
}
