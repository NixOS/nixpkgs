{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
  installShellFiles,
  versionCheckHook,
}:

let
  version = "2.8.0";
in
python3Packages.buildPythonApplication {
  pname = "ytcc";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "woefe";
    repo = "ytcc";
    tag = "v${version}";
    hash = "sha256-6Z5xoGbOtJnPlPj5GS9ElRkuuNd+ON9RsZyl5VLzLE0=";
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

  pythonRelaxDeps = [ "click" ];

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
    "test_cleanup"
    "test_pipe_mark"
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
