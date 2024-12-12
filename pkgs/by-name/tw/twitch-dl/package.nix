{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  scdoc,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "twitch-dl";
  version = "2.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "twitch-dl";
    rev = "refs/tags/${version}";
    hash = "sha256-BIE3+SDmc5ggF9P+qeloI1JYYrEtOJQ/8oDR76i0t6c=";
  };

  pythonRelaxDeps = [
    "m3u8"
  ];

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
    installShellFiles
    scdoc
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    httpx
    m3u8
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_api.py"
    "tests/test_cli.py"
  ];

  pythonImportsCheck = [
    "twitchdl"
    "twitchdl.cli"
    "twitchdl.naming"
    "twitchdl.entities"
    "twitchdl.http"
    "twitchdl.output"
    "twitchdl.playlists"
    "twitchdl.progress"
    "twitchdl.twitch"
    "twitchdl.utils"
    "twitchdl.commands"
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  postInstall = ''
    scdoc < twitch-dl.1.scd > twitch-dl.1
    installManPage twitch-dl.1
  '';

  preInstallCheck = ''
    export HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "CLI tool for downloading videos from Twitch";
    homepage = "https://github.com/ihabunek/twitch-dl";
    changelog = "https://github.com/ihabunek/twitch-dl/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      pbsds
      hausken
    ];
    mainProgram = "twitch-dl";
  };
}
