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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'm3u8>=1.0.0,<4.0.0' 'm3u8>=1.0.0'
  '';

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
  ];

  pythonImportsCheck = [
    "twitchdl"
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
    maintainers = with maintainers; [ ];
    mainProgram = "twitch-dl";
  };
}
