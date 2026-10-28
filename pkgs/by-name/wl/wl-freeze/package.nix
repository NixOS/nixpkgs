{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  jq,
  procps,
  libnotify,
  xdotool,
  xwininfo,
  kdotool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wl-freeze";
  version = "2.2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Zerodya";
    repo = "wl-freeze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Sz7uYgnrH4M0cjtyeEIPncjeumbYF50SzHzfi0JG8M=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 wl-freeze $out/bin/wl-freeze

    # Install shell completions
    installShellCompletion \
      --cmd wl-freeze \
      --bash completions/bash/wl-freeze \
      --zsh completions/zsh/_wl-freeze \
      --fish completions/fish/wl-freeze.fish

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/wl-freeze \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          procps
          libnotify
          xdotool
          xwininfo
          kdotool
        ]
      }
  '';

  meta = {
    description = "Utility to suspend a game process (and other programs) in Wayland compositors";
    homepage = "https://github.com/Zerodya/wl-freeze";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zerodya ];
    platforms = lib.platforms.linux;
    mainProgram = "wl-freeze";
  };
})
