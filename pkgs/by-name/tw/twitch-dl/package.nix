{ lib
, fetchFromGitHub
, python3Packages
, installShellFiles
, scdoc
}:

python3Packages.buildPythonApplication rec {
  pname = "twitch-dl";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "twitch-dl";
    rev = "refs/tags/${version}";
    hash = "sha256-Os27uqH3MA3v9+8WzfL5KIEUewAzf8JUyRtsWSzw81o=";
  };

  pythonRelaxDeps = [
    "m3u8"
  ];

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
    python3Packages.pythonRelaxDepsHook
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
  ];

  pythonImportsCheck = [
    "twitchdl"
    "twitchdl.cli"
    "twitchdl.download"
    "twitchdl.entities"
    "twitchdl.http"
    "twitchdl.output"
    "twitchdl.playlists"
    "twitchdl.progress"
    "twitchdl.twitch"
    "twitchdl.utils"
    "twitchdl.commands"
  ];

  postInstall = ''
    scdoc < twitch-dl.1.scd > twitch-dl.1
    installManPage twitch-dl.1
  '';

  meta = with lib; {
    description = "CLI tool for downloading videos from Twitch";
    homepage = "https://github.com/ihabunek/twitch-dl";
    changelog = "https://github.com/ihabunek/twitch-dl/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "twitch-dl";
  };
}
