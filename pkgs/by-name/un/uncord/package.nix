{
  lib,
  python3Packages,
  fetchFromGitHub,
  chafa,
  ffmpeg,
  libopus,
  mpv,
  pipewire,
  wl-clipboard,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "uncord";
  version = "0.75b";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "epwv";
    repo = "uncord";
    tag = "v${version}";
    hash = "sha256-dmX2YlZRWpkJ0IxNfiXXhZsJc6W1y5hn0bkhsZyffV8=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies =
    with python3Packages;
    [
      cryptography
      davey
      discord-py-self
      jeepney
      pillow
      pynacl
      rich
      segno
      textual
      textual-image
    ]
    ++ discord-py-self.optional-dependencies.voice
    ++ lib.optional (pythonAtLeast "3.13") audioop-lts;

  # upstream pins discord.py-self to a git commit, which is packaged above
  pythonRemoveDeps = [ "discord.py-self" ];
  pythonRelaxDeps = [ "textual" ];

  makeWrapperArgs = [
    # after the system path so setcap wrappers such as programs.gpu-screen-recorder win
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ffmpeg
      mpv
      pipewire
      wl-clipboard
    ])
    "--set-default"
    "UNCORD_FFMPEG"
    (lib.getExe ffmpeg)
    "--set-default"
    "UNCORD_OPUS"
    "${lib.getLib libopus}/lib/libopus.so.0"
    "--set-default"
    "UNCORD_CHAFA"
    "${lib.getLib chafa}/lib/libchafa.so.0"
  ];

  postInstall = ''
    install -Dm644 assets/icon.svg $out/share/icons/hicolor/scalable/apps/uncord.svg
    install -Dm644 packaging/uncord.desktop $out/share/applications/uncord.desktop
  '';

  pythonImportsCheck = [
    "uncord"
    "uncord._native"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Discord client for the terminal with voice calls, inline images and screen sharing";
    homepage = "https://github.com/epwv/uncord";
    changelog = "https://github.com/epwv/uncord/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ epwv ];
    mainProgram = "uncord";
    platforms = lib.platforms.linux;
  };
}
