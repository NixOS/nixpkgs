{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "zigpy-cli";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vY6mv5R7A4kVg4Z4nWdm5hgQv6fewyIbOrvhDUuiXa0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
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
    changelog = "https://github.com/zigpy/zigpy-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
})
