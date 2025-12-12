{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zigpy-cli";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-cli";
    tag = "v${version}";
    hash = "sha256-IwL69fZLbCvoliYB7Ne6nhe9QVoy9Wu55Mwca+mbucc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    bellows
    click
    coloredlogs
    scapy
    zigpy
    zigpy-deconz
    zigpy-xbee
    zigpy-zboss
    zigpy-zigate
    zigpy-znp
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zigpy_cli"
  ];

  meta = {
    description = "Command line interface for zigpy";
    mainProgram = "zigpy";
    homepage = "https://github.com/zigpy/zigpy-cli";
    changelog = "https://github.com/zigpy/zigpy-cli/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
}
