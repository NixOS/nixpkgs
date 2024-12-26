{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zigpy-cli";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-69E6PkrCE5S498pO33uEz7g2dV41H0vNfFinUHDATTQ=";
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

  meta = with lib; {
    description = "Command line interface for zigpy";
    mainProgram = "zigpy";
    homepage = "https://github.com/zigpy/zigpy-cli";
    changelog = "https://github.com/zigpy/zigpy-cli/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.linux;
  };
}
