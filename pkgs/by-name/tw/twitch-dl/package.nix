{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  scdoc,
  ffmpeg,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "twitch-dl";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "twitch-dl";
    tag = finalAttrs.version;
    hash = "sha256-scGTGlAt1k6eS8O3thrlJpVv3vZe2lKNBxtDYIBWOPg=";
  };

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
    wcwidth
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
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

  meta = {
    description = "CLI tool for downloading videos from Twitch";
    homepage = "https://github.com/ihabunek/twitch-dl";
    changelog = "https://github.com/ihabunek/twitch-dl/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      pbsds
      hausken
    ];
    mainProgram = "twitch-dl";
  };
})
