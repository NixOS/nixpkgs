{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
  installShellFiles,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "ytcc";
  version = "2.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "woefe";
    repo = "ytcc";
    tag = "v${version}";
    hash = "sha256-PNSkIp6CJvgirO3k2lB0nOVEC1+znhn3/OyRIJ1EANI=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [
    gettext
    installShellFiles
  ];

  dependencies = with python3Packages; [
    yt-dlp
    click
    wcwidth
    defusedxml
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
    ]
    ++ [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  # Disable tests that touch network or shell out to commands
  disabledTests = [
    "get_channels"
    "play_video"
    "download_videos"
    "update_all"
    "add_channel_duplicate"
    "test_subscribe"
    "test_import"
    "test_import_duplicate"
    "test_update"
    "test_download"
    "test_comma_list_error"
  ];

  postInstall = ''
    installManPage doc/ytcc.1
    installShellCompletion --cmd ytcc \
      --bash scripts/completions/bash/ytcc.completion.sh \
      --fish scripts/completions/fish/ytcc.fish \
      --zsh scripts/completions/zsh/_ytcc
  '';

  meta = {
    description = "Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account";
    homepage = "https://github.com/woefe/ytcc";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ytcc";
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
